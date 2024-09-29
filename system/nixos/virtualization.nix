{
  lib,
  inputs,
  pkgs,
}: {
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    docker-credential-helpers
  ];

  environment.systemPackages = with pkgs; [
    minikube
  ];
}
