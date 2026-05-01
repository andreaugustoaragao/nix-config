{pkgs, ...}: {
  nix = {
    package = pkgs.nixVersions.stable;
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
}
