{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://bw.faragao.net";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "8000";
    };
  };
  services.nginx.virtualHosts."bw.faragao.net" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
      recommendedProxySettings = true;
    };
  };
}
