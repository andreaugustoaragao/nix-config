{pkgs, ...}: {
  xresources = {
    properties = {
      "*.foreground" = "#e0def4";
      "*.background" = "#191724";
      "*.cursorColor" = "#e0def4";

      "*.color0" = "#191724";
      "*.color8" = "#555169";

      "*.color1" = "#eb6f92";
      "*.color9" = "#eb6f92";

      "*.color2" = "#31748f";
      "*.color10" = "#31748f";

      "*.color3" = "#f6c177";
      "*.color11" = "#f6c177";

      "*.color4" = "#9ccfd8";
      "*.color12" = "#9ccfd8";

      "*.color5" = "#c4a7e7";
      "*.color13" = "#c4a7e7";

      "*.color6" = "#ebbcba";
      "*.color14" = "#ebbcba";

      "*.color7" = "#e0def4";
      "*.color15" = "#e0def4";

      "XTerm*font" = "xft:JetbrainsMono Nerd Font:size=10";
      "XTerm*saveLines" = "1000";
      "XTerm*scrollBar" = "false";
      "Xft.dpi" = 144;
      "*.dpi" = 144;
      #"Xcursor.size" = 96;
      #"Xcursor.theme" = "Adwaita";
    };
  };
}
