{
  config,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode" "DroidSansMono" "Hack" "RobotoMono" "Terminus"];})
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    terminus_font
    roboto
    roboto-mono
    roboto-slab
    hasklig
    inter
    material-design-icons
    material-icons
    source-code-pro
    source-sans-pro
    weather-icons
    font-awesome
    corefonts
    vistafonts
  ];

  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    hinting = {
      enable = true;
      style = "slight";
    };
    subpixel.rgba = "rgb";
    subpixel.lcdfilter = "default";
    includeUserConf = false;
    antialias = true;
    enable = true;
    defaultFonts = {
      monospace = ["Roboto Mono 12"];
      sansSerif = ["Roboto 12"];
      serif = ["Roboto Slab 12"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
