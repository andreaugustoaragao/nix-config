{
  config,
  lib,
  pkgs,
  ...
}: {
  options.machine.virtualization.enable = lib.mkEnableOption "enables docker and kvm";

  config = lib.mkIf config.machine.virtualization.enable {
    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;

    programs.virt-manager.enable = config.machine.role == "pc";

    environment.systemPackages = with pkgs; [
      docker-credential-helpers
      minikube
    ];
  };
}
