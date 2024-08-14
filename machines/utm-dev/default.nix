# machine specific configuration goes here
{
  lib,
  inputs,
  system,
  config,
  pkgs,
  ...
}: let
  __curDir = builtins.toString ./.;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname
  networking.hostName = "utm-dev";

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [pkgs.mesa.drivers pkgs.virglrenderer];
  #hardware.opengl.driSupport = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  services.qemuGuest.enable = true;

  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.variables = {
    MESA_GL_VERSION_OVERRIDE = "3.3";
    MESA_GLSL_VERSION_OVERRIDE = "330";
  };

  services.upower.enable = true;
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
      gfxmodeEfi = "2560x1440";
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

  services.xserver.resolutions = [
    {
      x = 3840;
      y = 2160;
    }
  ];
}
