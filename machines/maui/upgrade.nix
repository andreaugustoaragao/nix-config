{pkgs, ...}: let
  hcPing = pkgs.writeShellScript "hc-ping" ''
    url=$(cat "$CREDENTIALS_DIRECTORY/hc-url")
    exec ${pkgs.curl}/bin/curl -fsS --retry 3 --max-time 10 "$url$1"
  '';
in {
  # libgit2 (used by nix flake fetchers) refuses to open repos whose
  # top-level dir is owned by a different user than the running process.
  # nixos-upgrade runs as root; the checkout is owned by adm.
  programs.git = {
    enable = true;
    config.safe.directory = "/home/adm/nix-config";
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:andreaugustoaragao/nix-config/main";
    flags = [
      "--refresh"
      "-L"
      "--update-input"
      "nixpkgs"
    ];
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
