{lib, ...}:
with lib; {
  config = {
    services.openssh.enable = mkDefault true;
    networking.firewall.allowedTCPPorts = [22];
  };
}
