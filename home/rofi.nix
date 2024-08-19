{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.rofi = {
    package = pkgs.rofi-wayland;
    enable = true;
    font = "Jetbrains Mono Nerd Font SemiBold 14";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      show-icons = true;
      display-drun = " ";
      icon-theme = "rose-pine";
      drun-display-format = "{name}";
      columns = 2;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#191724";
        bg-alt = mkLiteral "#585b70";
        bg-selected = mkLiteral "#313244";
        fg = mkLiteral "#ffffff";
        fg-alt = mkLiteral "#7f849c";

        border = 0;
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      "window" = {
        width = mkLiteral "25%";
        height = mkLiteral "20%";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px solid "; # Adjust the size and color as needed
        border-radius = mkLiteral "5px"; # Optional: if you want rounded corners
      };

      "element" = {
        padding = mkLiteral "8 12";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-alt";
      };

      "element selected" = {
        text-color = mkLiteral "@fg";
        background-color = mkLiteral "@bg-selected";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };

      "element-icon" = {
        size = 40;
        padding = mkLiteral "0 10 0 0";
        background-color = mkLiteral "transparent";
      };

      "entry" = {
        padding = 12;
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@fg";
      };

      "inputbar" = {
        children = map mkLiteral ["prompt" "entry"];
        background-color = mkLiteral "@bg";
      };

      "listview" = {
        background-color = mkLiteral "@bg";
        columns = 1;
        lines = 10;
      };

      "mainbox" = {
        children = map mkLiteral ["inputbar" "listview"];
        background-color = mkLiteral "@bg";
      };

      "prompt" = {
        enabled = true;
        padding = mkLiteral "12 0 0 12";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@fg";
      };
    };
  };
}
