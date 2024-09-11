{lib, ...}: {
  networking.hostName = "maui"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.interfaces.enp2s0.ipv4.addresses = [
    {
      address = "192.168.40.3";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.40.1";
  networking.nameservers = [
    "127.0.0.1"
  ];
  networking.enableIPv6 = false;
  networking.useDHCP = lib.mkForce false;
  networking.wireless.enable = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [80 443 53];
  networking.firewall.allowedUDPPorts = [53];
}
