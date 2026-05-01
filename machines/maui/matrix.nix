{lib, ...}: {
  users.users.continuwuity = {
    isSystemUser = true;
    group = "continuwuity";
  };
  users.groups.continuwuity = {};

  systemd.tmpfiles.rules = [
    "d /data/services/matrix 0700 continuwuity continuwuity -"
  ];

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
    after = ["data.mount"];
    requires = ["data.mount"];
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "continuwuity";
      Group = lib.mkForce "continuwuity";
      # database_path is hardcoded to /var/lib/continuwuity by the
      # module. Bind /data over it inside the service's namespace
      # only — doing this at the host level (via fileSystems) makes
      # systemd's StateDirectory step EBUSY at service start.
      BindPaths = ["/data/services/matrix:/var/lib/continuwuity"];
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
