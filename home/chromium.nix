{pkgs, ...}: let
  chromiumWideVine = pkgs.chromium.overrideAttrs {
    enableWideVine = true;
    enableVaapi = true;
  };
in {
  nixpkgs.config.overlays = [
    (self: super: {
      brave = super.brave.override {
        commandLineArgs = "--password-store=basic";
      };
    })
  ];
  programs.chromium = {
    enable = true;
    package = pkgs.brave; #pkgs.chromium;
    dictionaries = [
      pkgs.hunspellDictsChromium.en_US
    ];
    commandLineArgs = [
      "--password-store=gnome"
      "--disable-brave-rewards-extension"
      "--test-type"
      "--no-default-browser-check"
    ];
    extensions = [
      #{id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} #ublock origin
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";} #1password
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} #vimium
      {id = "noimedcjdohhokijigpfcbjcfcaaahej";} #rose-pine theme
      {id = "danncghahncanipdoajmakdbeaophenb";} #auto group tabs
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} #dark reader
    ];
  };
  nixpkgs.config.enableWideWine = true;
}
