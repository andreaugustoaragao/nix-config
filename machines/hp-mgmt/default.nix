# machine specific configuration goes here
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "hp-mgmt";
  networking.networkmanager.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [
    pkgs.mesa.drivers
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
  ];

  boot = {
    plymouth.enable = false;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "console=tty4" # make the boot really silent
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.dev.log_level=3"
      "udev.log_priority=3"
    ];
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
  services.fwupd.enable = true;
}
