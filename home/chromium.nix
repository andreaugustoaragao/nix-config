{pkgs, ...}: let
  chromiumWideVine = pkgs.brave.overrideAttrs {
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
    package = chromiumWideVine; #pkgs.chromium;
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
      #"--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,TabHoverCardImages,SmoothScrolling,WindowsScrollingPersonality"
      "--ozone-platform-hint=auto"
    ];
    extensions = [
      #{id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} #ublock origin
      #{id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";} #1password
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} #vimium
      {id = "noimedcjdohhokijigpfcbjcfcaaahej";} #rose-pine theme
      {id = "nngceckbapebfimnlniiiahkandclblb";} #bitwarden
      {id = "ljjmnbjaapnggdiibfleeiaookhcodnl";} #darktheme
    ];
  };
  nixpkgs.config.enableWideWine = true;
}
