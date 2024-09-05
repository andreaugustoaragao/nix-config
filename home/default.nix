{
  lib,
  inputs,
  system,
  config,
  pkgs,
  userDetails,
  desktopDetails,
  ...
}: let
  xresources = import ./xresources.nix {inherit desktopDetails;};
in {
  #home-manager.users.${userDetails.userName} = {
  imports = [
    ./firefox-webapp.nix
    ./i3.nix
    ./sway.nix
    ./waybar.nix
    ./alacritty.nix
    ./packages.nix
    ./vscode.nix
    ./shell.nix
    ./chromium.nix
    ./firefox.nix
    ./gtk.nix
    ./nvim.nix
    ./git.nix
    ./xdg.nix
    xresources
    ./screen-capture.nix
    ./qt.nix
    ./zathura.nix
    ./go.nix
    ./gpg.nix
    ./file-managers.nix
    ./mail.nix
  ];
  xsession.enable = true;
  home.sessionVariables = {
    JAVAX_NET_SSL_TRUSTSTORE = "$HOME/.config/java-cacerts";
    MINIKUBE_HOME = "$HOME/.config";
    DOCKER_CONFIG = "$HOME/.config/docker";
    AZURE_CONFIG_DIR = "$HOME/.config/azure";
  };

  xdg.configFile.".minikube/certs" = {
    source = ../system/nixos/certs;
    recursive = true;
  };
  services.blueman-applet.enable = true;
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.eww = {
    enable = true;
    configDir = ./eww;
  };

  services.playerctld.enable = true;
}
