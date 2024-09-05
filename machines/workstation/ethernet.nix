{lib, ...}: {
  networking.hostName = "workstation"; # Define your hostname.
  networking.domain = "faragao.net";
  networking.networkmanager.enable = true;
  networking.interfaces.enp4s0.ipv4.addresses = [
    {
      address = "192.168.0.20";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [
    "192.168.0.3"
  ];
  networking.enableIPv6 = false;
  networking.useDHCP = lib.mkForce false;
  networking.wireless.enable = false;
}
