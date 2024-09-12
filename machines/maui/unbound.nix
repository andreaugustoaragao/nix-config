{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.dig
  ];
  services.unbound = {
    enable = true;
    checkconf = false;
    settings = {
      remote-control.control-enable = true;
      server = {
        extended-statistics = true;
        interface = ["127.0.0.1"];
        port = 5335;
        access-control = ["127.0.0.1 allow"];

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        hide-identity = true;
        hide-version = true;
        num-threads = 2;
        rrset-cache-size = "256m";
        msg-cache-size = "128m";
        cache-min-ttl = 0;
        serve-expired = true;
        #outgoing-range=462;
        so-rcvbuf = "1m";
        so-reuseport = true;
        local-zone = "\"faragao.net.\" static"; # Define your local zone
        # Define local DNS records
        local-data = [
          "\"maui.faragao.net.            IN A 192.168.40.3\""
          "\"teka.faragao.net.            IN A 192.168.40.4\""
          "\"adguard.faragao.net.         IN A 192.168.40.3\""
          "\"monitoring.faragao.net.      IN A 192.168.40.3\""
          "\"vw.faragao.net.              IN A 192.168.40.3\""
          "\"tamatoa-mgmt.faragao.net.    IN A 192.168.40.3\""
          "\"chief-tui-mgmt.faragao.net.  IN A 192.168.40.3\""
          "\"teka-web.faragao.net.        IN A 192.168.40.3\""
        ];
        local-data-ptr = [
          "\"192.168.40.3  maui.faragao.net.\""
          "\"192.168.40.4  teka.faragao.net.\""
        ];
      };
    };
  };
}
