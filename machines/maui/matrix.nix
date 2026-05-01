{
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = "matrix.faragao.net";
      address = ["127.0.0.1"];
      port = [6167];
      allow_federation = false;
      allow_encryption = true;
      # Flip to false after creating the first user; see commit message.
      allow_registration = true;
      max_request_size = 20000000;
    };
  };

  services.nginx.virtualHosts."matrix.faragao.net" = {
    forceSSL = true;
    useACMEHost = "faragao.net";
    locations."/" = {
      proxyPass = "http://127.0.0.1:6167";
      recommendedProxySettings = true;
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 20M;
      '';
    };
  };
}
