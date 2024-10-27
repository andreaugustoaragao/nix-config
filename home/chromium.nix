{pkgs, ...}: let
  chromiumWideVine = pkgs.brave.overrideAttrs {
    enableWideVine = true;
    enableVaapi = true;
  };
  qutebrowserWideVine = pkgs.qutebrowser.overrideAttrs {
    enableWideVine = true;
    enableVulkan = true;
  };
in {
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

  nixpkgs.config.enableWideVine = true;

  home.file.".config/qutebrowser/config.py" = {
    source = ./qutebrowser/config.py;
    executable = false;
  };
  home.packages = [
    pkgs.qutebrowser
    #qutebrowserWideVine
  ];
}
