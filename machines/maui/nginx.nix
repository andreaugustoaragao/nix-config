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
    };
  };

  users.users.nginx.extraGroups = ["acme"];
}
