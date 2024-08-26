{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../system/nixos/nix.nix
    ./ethernet.nix
    ./unbound.nix
    ./adguard.nix
    ./nginx.nix
    ./editor.nix
    ./tmux.nix
  ];

  networking.hostName = "maui"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.main = {
    isNormalUser = true;
    description = "main";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    htop
    entr
    fd
    alejandra
    nil
    ripgrep
    black
    codespell
    isort
    jq
    shfmt
    busybox
  ];

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
    };
  };

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    interfaces."eth0".allowedTCPPorts = [80 443];
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
    '';
  };
  system.stateVersion = "24.05";
}
