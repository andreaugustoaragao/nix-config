{
  lib,
  inputs,
  system,
  config,
  pkgs,
  userDetails,
  desktopDetails,
  ...
}: {
  home-manager.users.${userDetails.userName} = {
    imports = [
      ./firefox-webapp.nix
      ./i3.nix
      ./rofi.nix
      ./alacritty.nix
      ./packages.nix
      ./polybar.nix
      ./picom.nix
      ./redshift.nix
      ./vscode.nix
      ./shell.nix
      ./chromium.nix
      ./firefox.nix
      ./gtk.nix
      ./nvim.nix
      ./git.nix
      ./xdg.nix
      ./xresources.nix
      ./screen-capture.nix
      ./qt.nix
      ./zathura.nix
      ./go.nix
      ./gpg.nix
      ./dunst.nix
      ./file-managers.nix
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
    services.pasystray.enable = true;
    services.blueman-applet.enable = true;
  };
}
