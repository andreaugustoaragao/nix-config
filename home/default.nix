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
    ./xresources.nix
    ./screen-capture.nix
    ./qt.nix
    ./zathura.nix
    ./go.nix
    ./gpg.nix
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
  services.blueman-applet.enable = true;
  #services.xscreensaver = {
  #  enable = true;
  #   settings = {
  #    timeout = 1;
  #    mode = "blank";
  #  };
  #};
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
