{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vw.faragao.net";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "8000";
      SIGNUPS_ALLOWED = false;
      SIGNUPS_DOMAINS_WHITELIST = "faragao.net";
      INVITATIONS_ALLOWED = false;
      PUSH_ENABLED = true;
      PUSH_INSTALLATION_ID = "866aa8fa-021b-44cc-bad7-b1dd01818d12";
      PUSH_INSTALLATION_KEY = "ASYGSL9hqgeHhLrkwk5M";
      #DATA_FOLDER = "/data/services/vw/data";
    };
    environmentFile = "/data/services/vw/vw.env";
    backupDir = "/data/services/vw/backup";
  };
  services.nginx.virtualHosts."vw.faragao.net" = {
    forceSSL = true;
    useACMEHost = "faragao.net";
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
      recommendedProxySettings = true;
      proxyWebsockets = true;
    };
  };
}
