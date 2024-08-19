{pkgs, ...}: let
  #background = "#282A2E";
  #background-alt = "#373B41";
  #foreground = "#C5C8C6";
  #primary = "#F0C674";
  #secondary = "#8ABEB7";
  #alert = "#A54242";
  #disabled = "#707880";
  background = "#FF191724";
  background-transparent = "#FF191724";
  background-alt = "#26233a";
  foreground = "#e0def4";
  #background-transparent = "#e0def4";
  #foreground="#191724";
  #https://materialpalettes.com/
  primary = "#f6c177";
  secondary = "#124d63";
  tertiary = "#31748f";
  quaternary = "#5b96b2";
  quinary = "#b4def0";

  alert = "#eb6f92";
  disabled = "#6e6a86";
  background-modules = "#21202e";
  # Get the directory of the current file
  __curDir = builtins.toString ./.;
in {
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;
        auto-hide = true;
        auto-hide-timeout = 10;
        output = [
          "DP-1"
        ];
        modules-left = ["sway/workspaces" "sway/mode" "wlr/taskbar"];
        modules-center = ["sway/window" "custom/hello-from-waybar"];
        modules-right = ["mpd" "custom/mymodule#with-css-id" "temperature"];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      }
    ];
  };
}
