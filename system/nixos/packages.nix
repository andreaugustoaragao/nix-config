{
  lib,
  inputs,
  system,
  config,
  pkgs,
  ...
}: {
  # available to root and ${userDetails.userName}
  environment.systemPackages = with pkgs; [
    lf
    starship
    inetutils
    unzip
    zip
    unrar
    p7zip
    tree
    fzf
    fortune
    dwt1-shell-color-scripts
    git
    curl
    wget
    killall
    htop
    fzf
    ripgrep
    entr
    lolcat
    cowsay
    nixd
    fd
    lua-language-server
    nodePackages_latest.bash-language-server
    p11-kit #used to generate java ca-certs
    glxinfo
    minikube
    openssl
    nix-prefetch-github
    redis
    onefetch
    speedtest-cli

    pasystray
  ];
}
