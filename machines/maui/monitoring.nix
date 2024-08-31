{
  config,
  pkgs,
  ...
}: {
  services.prometheus.exporters.unbound = {
    enable = true;
    port = 9102;
  };
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [
      "logind"
      "systemd"
      "processes"
    ];
    disabledCollectors = [
      "textfile"
    ];
  };
  # https://wiki.nixos.org/wiki/Prometheus
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters-configuration
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/default.nix
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.unbound.port}"];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings.server.domain = "monitoring.faragao.net";
    settings.server.http_port = 2342;
    settings.server.http_addr = "127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    forceSSL = true;
    useACMEHost = "faragao.net";
    #sslCertificate = "/data/services/nginx/cloudflare/certs/origin_cert.pem";
    #sslCertificateKey = "/data/services/nginx/cloudflare/certs/origin_private.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
