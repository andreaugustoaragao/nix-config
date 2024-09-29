{
  inputs,
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

  nixpkgs.config.permittedInsecurePackages = [
    #  "electron-29.4.6"
  ];

  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "--flake .#$(/run/current-system/sw/bin/hostname)"
      "-L" # print build logs
    ];
    dates = "17:00";
    randomizedDelaySec = "45min";
    persistent = true;
  };

  systemd.services.nixos-upgrade.onFailure = ["notify-failure@nixos-upgrade.service"];

  environment.systemPackages = [
    pkgs.mailutils
  ];

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
      andre-a-o-aragao@proton.me \
      <<EOF
      $(systemctl status -n 1000000 "$unit")
      $extra_information
      EOF
    '';
  };
}
