{
  lib,
  pkgs,
  ...
}: let
  # Hits continuwuity directly on localhost rather than going through
  # matrix.faragao.net -> Cloudflare -> nginx -> continuwuity. That
  # means alerts can still fire when nginx, unbound, adguardhome, or
  # the cert chain are the failing service.
  matrixAlert = pkgs.writeShellScript "matrix-alert" ''
    set -euo pipefail

    unit="''${1:-unknown}"
    host=$(${pkgs.nettools}/bin/hostname)
    msg="$unit failed on $host"

    token=$(cat /data/services/matrix/bot-token)
    room=$(cat /data/services/matrix/alert-room-id)
    txn=$(date +%s%N)

    body=$(${pkgs.jq}/bin/jq -n --arg body "$msg" '{msgtype:"m.text",body:$body}')

    exec ${pkgs.curl}/bin/curl -fsS --retry 3 --max-time 15 -X PUT \
      "http://127.0.0.1:6167/_matrix/client/v3/rooms/$room/send/m.room.message/$txn" \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json" \
      -d "$body"
  '';

  # Services whose failure should land in the Matrix alert room. Each
  # name produces an OnFailure=matrix-alert@<name>.service link.
  # continuwuity itself is intentionally excluded — if the homeserver
  # is down, the alert can't be delivered through it.
  alertedServices = [
    "vaultwarden"
    "unbound"
    "adguardhome"
    "nginx"
    "acme-faragao.net"
    "smbd"
    "prometheus"
    "grafana"
  ];
in {
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
      allow_registration = false;
      new_user_displayname_suffix = "";
      max_request_size = 20000000;
    };
  };

  systemd.services =
    {
      matrix-continuwuity = {
        after = ["data.mount"];
        requires = ["data.mount"];
        serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = lib.mkForce "continuwuity";
          Group = lib.mkForce "continuwuity";
          BindPaths = ["/data/services/matrix:/var/lib/continuwuity"];
        };
      };

      "matrix-alert@" = {
        description = "Post Matrix alert for %i";
        unitConfig = {
          ConditionPathExists = [
            "/data/services/matrix/bot-token"
            "/data/services/matrix/alert-room-id"
          ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${matrixAlert} %i";
        };
      };
    }
    // lib.genAttrs alertedServices (name: {
      onFailure = ["matrix-alert@${name}.service"];
    });

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
