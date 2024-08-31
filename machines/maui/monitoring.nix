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
    domain = "monitoring.faragao.net";
    port = 2342;
    addr = "127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
