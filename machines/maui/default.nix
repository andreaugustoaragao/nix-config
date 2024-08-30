{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    #(modulesPath + "/profiles/headless.nix")
    #(modulesPath + "/profiles/minimal.nix")

    ./hardware-configuration.nix
    ../../system/nixos/nix.nix
    ./ethernet.nix
    ./unbound.nix
    ./adguard.nix
    ./nginx.nix
    ./editor.nix
    ./tmux.nix
  ];

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
  users.users.adm = {
    isNormalUser = true;
    description = "main";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  xdg.icons.enable = false;
  xdg.mime.enable = false;
  xdg.sounds.enable = false;
  documentation.man.enable = false;
  environment.defaultPackages = lib.mkForce [];
  environment.systemPackages = with pkgs; [
    fastfetch
    fortune
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #services.dbus.enable = lib.mkForce true;
  #security.polkit.enable = lib.mkForce false;

  #to enable special font in kmscon
  fonts.fontconfig.enable = lib.mkForce true;
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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      function fish_greeting
        fastfetch
        fortune
      end
    '';
  };

  programs.starship = {
    enable = true;
  };

  system.stateVersion = "24.05";
}
