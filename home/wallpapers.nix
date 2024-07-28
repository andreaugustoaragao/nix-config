{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "rose-pine-wallpapers";
  src = pkgs.fetchgit {
    url = "https://github.com/rose-pine/wallpapers";
    #rev = "main";  # Specify the commit, tag, or branch you want to download.
    sha256 = "7jaFqVXs6T3S818IBD3CLjNgDYuc5/ibMWCCnlbtUHw=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
