{pkgs, ...}: let
  chromiumWideVine = pkgs.chromium.overrideAttrs {
    enableWideVine = true;
    enableVaapi = true;
  };

  chromePreferencesPatch = pkgs.writeScriptBin "patch-brave-preferences" ''
    #!/bin/bash

    PREFERENCES_FILE="$HOME/.config/BraveSoftware/Brave-Browser/Default/Preferences"
    DOWNLOAD_DIR="$HOME/downloads"

    # Use jq to update the download directory in the Preferences file
    jq --arg dir "$DOWNLOAD_DIR" '.download.default_directory = $dir' "$PREFERENCES_FILE" > "\$\{PREFERENCES_FILE}.tmp" && mv "\$\{PREFERENCES_FILE}.tmp" "\$\{PREFERENCES_FILE}"
  '';
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
      "--enable-gpu-rasterization"
      "--enable-parallel-downloading"
      "--disable-native-brave-wallet"
      "--enable-features=TabHoverCardImages,SmoothScrolling,WindowsScrollingPersonality"
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
  home.packages = [chromePreferencesPatch];

  home.activation = {
    # Run the script after home-manager activation
    patchBravePreferences = pkgs.lib.mkAfter ''
      "${chromePreferencesPatch}"/bin/patch-brave-preferences
    '';
  };
}
