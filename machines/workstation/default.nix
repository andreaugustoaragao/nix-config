{
  system,
  pkgs,
  ...
}: let
  __curDir = builtins.toString ./.;
in {
  imports = [
    ./hardware-configuration.nix
    #./fix-suspend.nix
    ./ethernet.nix
    ./sleep.nix
  ];

  # Hostname
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;

  hardware.graphics.extraPackages = [
    pkgs.mesa.drivers
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    # pkgs.amdvlk
    pkgs.rocmPackages.clr.icd
    pkgs.vulkan-loader
    #pkgs.vulkan-validation-layers
    pkgs.vulkan-extension-layer
  ];
  hardware.graphics.extraPackages32 = [
    #pkgs.driversi686Linux.amdvlk
  ];

  hardware.amdgpu.initrd.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    plymouth
  ];
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  services.xserver.screenSection = ''
    #DefaultDepth 30 #disabled as it makes brave looks bad
    Monitor "DisplayPort-0"
  '';

  services.xserver.config = ''
    Section "Monitor"
      Identifier "DisplayPort-0"
      Modeline   "3840x2160_144" 1339.63 3840 3888 3920 4200 2160 2163 2168 2215 +HSync -VSync
      Option     "PreferredMode" "3840x2160_144"
    EndSection
  '';

  # services.xserver.monitorSection = ''
  #  Modeline   "3840x2160_144" 1339.63 3840 3888 3920 4200 2160 2163 2168 2215 +HSync -VSync
  #   Option     "PreferredMode" "3840x2160_144"
  #'';

  #services.xserver.displayManager.setupCommands = ''
  #${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --mode "3840x2160" --rate 144
  #'';

  #  systemd.services.plymouth-quit-wait = {
  #    wantedBy = ["multi-user.target"];
  #    after = ["systemd-user-sessions.service"];
  #  };

  boot = {
    plymouth = {
      enable = false;
      #theme = "abstract_ring";
      theme = "catppuccin-macchiato";
      themePackages = with pkgs; [
        catppuccin-plymouth
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["abstract_ring"];
        })
      ];
    };

    initrd.enable = true;
    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "console=tty4"
      "quiet"
      "splash"
      "$vt_hadoff"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    # :loader.timeout = 0;
  };
  boot.loader.systemd-boot.enable = false;
  #boot.initrd.systemd.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";

    grub = {
      efiInstallAsRemovable = false;
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
      backgroundColor = "#24273a";
      splashImage = "${__curDir}/grub-background.png";
      gfxmodeEfi = "2560x1440";
      gfxpayloadEfi = "keep";
      configurationLimit = 20;
      extraEntries = ''
      '';
    };
  };

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.upower.enable = true;
  #services.blueman.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [pkgs.hplip];
  services.printing.startWhenNeeded = true; # optional
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.sane-airscan];
  hardware.sane.disabledDefaultBackends = ["escl"];
  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = false;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = ["multi-user.target"];
  };
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "DroidSansM Nerd Font Mono";
        package = pkgs.nerdfonts;
      }
    ];
    extraOptions = ''
    '';
    hwRender = true;
    extraConfig = ''
      font-size=12
      font-dpi=144
    '';
  };
}
