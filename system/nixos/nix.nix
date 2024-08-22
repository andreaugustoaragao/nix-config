{
  lib,
  inputs,
  system,
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--flake .#$(hostname)"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  systemd.services.nixos-upgrade.onFailure = ["notify-failure@nixos-upgrade.service"];
  systemd.services."notify-failure@" = {
    enable = true;
    description = "Failure notification for %i";
    scriptArgs = ''"%i" "Hostname: %H" "Machine ID: %m" "Boot ID: %b"'';
    script = ''
      unit="$1"
      extra_information=""
      for e in "''${@:2}"; do
        extra_information+="$e"$'\n'
      done
      ${pkgs.mailutils}/bin/mail \
      --subject="Service $unit failed on $2" \
      recipient@example.com \
      <<EOF
      $(systemctl status -n 1000000 "$unit")
      $extra_information
      EOF
    '';
  };
}
