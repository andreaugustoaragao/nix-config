{
  services.nginx = {
    enable = true;
    resolver.ipv4 = true;
    resolver.ipv6 = false;
    resolver.addresses = ["127.0.0.1"];
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    commonHttpConfig = ''
      ssl_certificate /data/services/nginx/cloudflare/certs/origin_cert.pem;
      ssl_certificate_key /data/services/nginx/cloudflare/certs/origin_private.pem;
    '';
    virtualHosts = {
      "faragao.net" = {
        serverAliases = ["*.faragao.net"];
        locations."/" = {
          return = "301 https://$host$request_uri";
        };
      };
      "teka-web.faragao.net" = {
        forceSSL = true;
        useACMEHost = "faragao.net";
        locations."/" = {
          proxyPass = "https://192.168.40.4:5001";
        };
      };
      "tamatoa-mgmt.faragao.net" = {
        forceSSL = true;
        useACMEHost = "faragao.net";
        locations."/" = {
          proxyPass = "https://192.168.0.1";
        };
      };
      "chief-tui-mgmt.faragao.net" = {
        forceSSL = true;
        useACMEHost = "faragao.net";
        locations."/" = {
          proxyPass = "https://192.168.0.2";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];
}
