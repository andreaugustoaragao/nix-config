{
  system,
  pkgs,
  ...
}: let
  __curDir = builtins.toString ./.;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "workstation";
  networking.wireless.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;

  hardware.display.outputs."DP-1".mode = "e";

  hardware.graphics.extraPackages = [
    pkgs.mesa.drivers
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    pkgs.amdvlk
    pkgs.rocmPackages.clr.icd
    pkgs.vulkan-loader
    pkgs.vulkan-validation-layers
    pkgs.vulkan-extension-layer
  ];
  hardware.graphics.extraPackages32 = [
    pkgs.driversi686Linux.amdvlk
  ];
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.amdvlk.enable = true;

  hardware.amdgpu.opencl.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    plymouth
  ];
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.resolutions = [
    {
      x = 3840;
      y = 2160;
    }
  ];

  systemd.services.plymouth-quit-wait = {
    wantedBy = ["multi-user.target"];
    after = ["systemd-user-sessions.service"];
  };
  boot = {
    plymouth = {
      enable = true;
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
  boot.initrd.systemd.enable = true;
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
      gfxmodeEfi = "1920x1080";
      gfxpayloadEfi = "keep";
      extraEntries = ''
        menuentry "Video Info" {
            videoinfo
        }
        menuentry "Reboot" {
            reboot
        }
        menuentry "Poweroff" {
            halt
        }
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
  services.blueman.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [pkgs.hplip];
  services.printing.startWhenNeeded = true; # optional
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.sane-airscan];
  hardware.sane.disabledDefaultBackends = ["escl"];
  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    wantedBy = ["multi-user.target"];
  };
}
