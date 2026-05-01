{pkgs, ...}: let
  hcPing = pkgs.writeShellScript "hc-ping" ''
    url=$(cat "$CREDENTIALS_DIRECTORY/hc-url")
    exec ${pkgs.curl}/bin/curl -fsS --retry 3 --max-time 10 "$url$1"
  '';
in {
  system.autoUpgrade = {
    enable = true;
    flake = "git+file:///home/adm/nix-config?ref=main";
    flags = ["--refresh" "-L"];
    operation = "switch";
    dates = "Sun 03:00";
    randomizedDelaySec = "45min";
    persistent = true;
  };

  systemd.services.nixos-upgrade = {
    serviceConfig = {
      LoadCredential = "hc-url:/data/services/healthchecks/maui-upgrade.url";
      ExecStartPre = "-${hcPing} /start";
      ExecStartPost = "-${hcPing}";
    };
    onFailure = ["hc-ping-fail.service"];
  };

  systemd.services.hc-ping-fail = {
    description = "Ping healthchecks.io on nixos-upgrade failure";
    serviceConfig = {
      Type = "oneshot";
      LoadCredential = "hc-url:/data/services/healthchecks/maui-upgrade.url";
      ExecStart = "${hcPing} /fail";
    };
  };
}
