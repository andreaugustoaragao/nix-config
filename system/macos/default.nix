{pkgs, ...}: {
  ## NIX #########################
  nix = {
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      #interval = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;

  ## USERS ##########################
  users.users.aragao = {
    home = "/Users/aragao";
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  environment = {
    shells = with pkgs; [fish];
    loginShell = "${pkgs.fish}/bin/fish -l";
    pathsToLink = ["/Applications"];
  };

  ## FONTS ##########################
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["JetBrainsMono" "FiraCode" "DroidSansMono"];
    })
    dejavu_fonts
    roboto
    roboto-mono
  ];

  ## PACKAGES
  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    less
    curl
    speedtest-cli
    coreutils
    nixfmt
    jq
    nodePackages.bash-language-server
    nixd
    gdu

    inetutils
    unzip
    zip
    unrar
    p7zip
    tree
    fzf
    fortune
    lolcat
    cowsay
    dwt1-shell-color-scripts
    curl
    wget
    killall
    htop
    btop
    bottom
    gdu
    entr
    nixd
    lua-language-server
    p11-kit
    nix-prefetch-github
    onefetch
    bc
    cmatrix
    ripgrep
    entr
    openssl
    git
    dig.dnsutils
    bat
    alejandra
    nixfmt-classic
    zoxide
    fastfetch
  ];

  ## HOMEBREW
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
      cleanup = "zap";
    };
    global.brewfile = true;
    caskArgs.no_quarantine = true;
    taps = [
      "FelixKratz/formulae"
    ];
    brews = [
      "borders"
      "cava"
    ];
    casks = [
      "stats"
      "brave-browser"
      "1password"
      "sf-symbols"
      "parallels"
      "utm"
      "obsidian"
      "flameshot"
      "alacritty"
      #"qutebrowser"
      #"bitwarden"
      "nikitabobko/tap/aerospace"
    ];
  };

  ## MAC OS X #######################
  system.startup.chime = false;
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 3;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  system.defaults.LaunchServices.LSQuarantine = false;
  system.defaults.NSGlobalDomain.AppleFontSmoothing = 2;
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  #system.defaults.universalaccess.reduceMotion = true;
  #system.defaults.universalaccess.mouseDriverCursorSize = 2.0;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.minimize-to-application = true;
  system.defaults.dock.launchanim = false;
  system.defaults.dock.mineffect = null; # suck, genie, scale, null
  system.defaults.dock.tilesize = 16;
  system.defaults.dock.static-only = true;
  system.defaults.dock.autohide-delay = 1000.0;

  system.defaults.dock.appswitcher-all-displays = true;
  system.defaults.dock.show-recents = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.CreateDesktop = false;
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder._FXSortFoldersFirst = true;

  system.defaults.WindowManager.StandardHideDesktopIcons = true;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  security.pam.enableSudoTouchIdAuth = true;
  system.stateVersion = 5;

  #https://github.com/FelixKratz/dotfiles/tree/e6288b3f4220ca1ac64a68e60fced2d4c3e3e20b
}
