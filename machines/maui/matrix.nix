{
  lib,
  pkgs,
  ...
}: let
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
      "https://matrix.faragao.net/_matrix/client/v3/rooms/$room/send/m.room.message/$txn" \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json" \
      -d "$body"
  '';
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
      # Reopened only to register the @maui-alerts bot account; will
      # close again in the next commit.
      allow_registration = true;
      registration_token_file = "/data/services/matrix/registration_token";
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
      BindPaths = ["/data/services/matrix:/var/lib/continuwuity"];
    };
  };

  # Templated alert unit: invoke as matrix-alert@<failed-service>.service
  # via OnFailure=. Posts a one-line message into the room whose ID is
  # stored at /data/services/matrix/alert-room-id, authenticated with
  # the access token at /data/services/matrix/bot-token. Both files are
  # created by install/setup-matrix-bot.sh.
  systemd.services."matrix-alert@" = {
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
