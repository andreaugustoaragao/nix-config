# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  lib,
  inputs,
  system,
  config,
  pkgs,
  userDetails,
  ...
}: {
  imports = [
    ./nix.nix
    ./packages.nix
    ./fonts.nix
    ./locale.nix
    ./kernel.nix
    ./certs.nix
    #./x11.nix
    ./wayland.nix
    ./tmux
    ./openssh.nix
  ];
  nixpkgs.overlays = [
    inputs.nurpkgs.overlay
  ];

  # NETWORK
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  programs.nm-applet.enable = true;

  # SECURITY
  security.polkit.enable = true;
  security.rtkit.enable = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.sudo.wheelNeedsPassword = false;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = ["${userDetails.userName}"];
  };

  # USER SETUP
  users.users = {
    ${userDetails.userName} = {
      createHome = true;
      description = "${userDetails.fullName}";
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager" "lp" "scanner" "libvirtd"];
      shell = pkgs.fish;
      password = "password";
    };
  };
  users.mutableUsers = true;
  programs.fish.enable =
    true; # make shell assertion happy, it doesn't know about home manager.
  environment.pathsToLink = ["/libexec"];
  environment.binsh = "${pkgs.dash}/bin/dash"; #faster, consumes less memory
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
  # DOCKER and MINIKUBE
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    docker-credential-helpers
  ];

  # LOCATION SERVICES
  services.geoclue2.enable = true;
  location.provider = "geoclue2";
  services.localtimed.enable = true;

  # MISC
  documentation.man.generateCaches = true;

  programs.nix-ld.enable = true;

  programs.command-not-found.enable = false;

  environment.variables = {
    XSECURELOCK_SAVER = "saver_xscreensaver";
    #GDK_SCALE = "2";
    #GDK_DPI_SCALE = "0.5";
    #_JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
    #QT_SCALE_FACTOR = "1";
  };

  environment.localBinInPath = true;

  services.envfs.enable = true;

  system.stateVersion = "24.05"; # Do not change this number?
  #github.com/R-VdP/nixos-config
}
