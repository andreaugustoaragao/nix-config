{lib, ...}: {
  networking = {
    hostName = "workstation";
    domain = "faragao.net";
    useDHCP = lib.mkForce false;
    firewall.enable = false;

    wireless.enable = lib.mkForce false;
    enableIPv6 = lib.mkForce false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    #wait-online.anyInterface = true;
    networks = {
      "10-enp9s0f0" = {
        matchConfig.Name = "enp9s0f0";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = false;
        };
        dhcpV4Config = {
          UseDNS = true;
          UseRoutes = true;
          UseNTP = true;
          UseDomains = true;
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    #dnssec = "allow-downgrade";
    llmnr = "false";
    fallbackDns = ["192.168.40.3"];
  };

  services.dnsmasq.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  systemd.services = {
    modem-manager = {
      enable = false;
      restartIfChanged = false;
    };
  };

  systemd.services = {
    wpa_supplicant = {
      enable = false;
      restartIfChanged = false;
    };
  };
}
