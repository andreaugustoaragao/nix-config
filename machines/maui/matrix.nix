{lib, ...}: {
  users.users.continuwuity = {
    isSystemUser = true;
    group = "continuwuity";
  };
  users.groups.continuwuity = {};

  systemd.tmpfiles.rules = [
    "d /data/services/matrix 0700 continuwuity continuwuity -"
  ];

  # database_path is hardcoded to /var/lib/continuwuity by the module.
  # Bind-mount it onto /data so the actual storage lives on the btrfs
  # RAID 1, while the service sees the path it expects.
  fileSystems."/var/lib/continuwuity" = {
    device = "/data/services/matrix";
    fsType = "none";
    options = ["bind"];
    depends = ["/data"];
  };

  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = "matrix.faragao.net";
      address = ["127.0.0.1"];
      port = [6167];
      allow_federation = false;
      allow_encryption = true;
      # Flip to false after creating the first user.
      allow_registration = true;
      max_request_size = 20000000;
    };
  };

  systemd.services.matrix-continuwuity = {
    after = ["data.mount" "var-lib-continuwuity.mount"];
    requires = ["data.mount" "var-lib-continuwuity.mount"];
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "continuwuity";
      Group = lib.mkForce "continuwuity";
      # The bind mount above puts /var/lib/continuwuity on /data, so
      # systemd's StateDirectory machinery would fight us trying to
      # chown/manage a mountpoint. Let the mount handle it.
      StateDirectory = lib.mkForce "";
      ReadWritePaths = ["/var/lib/continuwuity"];
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
