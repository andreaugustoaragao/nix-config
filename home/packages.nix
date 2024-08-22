{pkgs, ...}:
with pkgs; let
  default-python = python3.withPackages (python-packages:
    with python-packages; [
      pip
      virtualenv
      black
      flake8
      setuptools
      wheel
      twine
    ]);
in {
  home.packages = with pkgs; [
    # TERMINAL
    any-nix-shell
    neofetch
    fastfetch
    escrotum # screen recording
    gnupg
    feh
    cdrkit # to create iso files
    bluetuith
    # DEVELOPMENT
    #jetbrains.idea-ultimate
    #jetbrains.goland
    default-python
    jdk17
    gradle
    maven
    gcc
    m4
    gnumake
    binutils
    gdb
    rustup
    lua-language-server
    nil
    alejandra # nix code formatter
    shellcheck
    lazygit
    stylua
    nodePackages.eslint
    codespell
    # kafka
    avro-tools
    kcat
    delve
    jdt-language-server
    markdownlint-cli
    shfmt

    # cloud
    kubectl
    stern
    kubelogin
    kubernetes-helm
    k9s
    azure-cli
    lazydocker

    # SYSADMIN
    remmina

    # DEFAULT
    pavucontrol
    neovide
    fd
    libnotify
    jq
    yq
    gdu
    zathura
    asciinema
    flameshot
    evince
    foliate
    inkscape-with-extensions
    libreoffice
    _1password-gui
    teams-for-linux
    gimp
    calibre
    #zoom-us
    cheese
  ];
}
