{pkgs, ...}: let
  # ROSE PINE
  # Base Colors
  base = "#191724"; # The main background color (very dark purple)
  surface = "#1f1d2e"; # A slightly lighter background (dark purple)
  overlay = "#26233a"; # Overlay background (dark desaturated purple)
  muted = "#6e6a86"; # Muted color for less prominent elements (grayish purple)

  # Text Colors
  text = "#e0def4"; # Main text color (soft white)
  subtle = "#908caa"; # Subtle text (desaturated purple)
  love = "#eb6f92"; # Accents like errors or important messages (soft red/pink)

  # Accent Colors
  gold = "#f6c177"; # Warm accent (soft gold)
  rose = "#ebbcba"; # Another warm accent, but softer (rosy pink)
  pine = "#31748f"; # Cool accent (muted cyan)
  foam = "#9ccfd8"; # Another cool accent (light cyan)
  iris = "#c4a7e7"; # Violet accent (light purple)
  highlightLow = "#21202e"; # Highlight background (dark purple, close to `surface`)
  highlightMed = "#403d52"; # Medium highlight (muted purple)
  highlightHigh = "#524f67"; # High contrast highlight (grayish purple)

  base_light = "#26233a";
  base_dark = "#1a1828";
  surface_light = "#302d41";
  surface_dark = "#1a182a";
  overlay_light = "#393552";
  overlay_dark = "#232136";
  muted_light = "#7a778e";
  muted_dark = "#5e5a78";
  subtle_light = "#a8a4c0";
  subtle_dark = "#7c7990";
  text_light = "#f2f0fc";
  text_dark = "#cdcbe3";
  love_light = "#f297af";
  love_dark = "#c6557f";
  gold_light = "#f8d79e";
  gold_dark = "#d5a76b";
  rose_light = "#f3c9c7";
  rose_dark = "#d28e89";
  pine_light = "#4696ae";
  pine_dark = "#235f75";
  foam_light = "#b2dfe8";
  foam_dark = "#6ca8b6";
  iris_light = "#d2c1f0";
  iris_dark = "#8e79b2";

  # Get the directory of the current file
  __curDir = builtins.toString ./.;
in {
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        auto-hide = false;
        auto-hide-timeout = 10;
        margin-top = 5;
        height = 40;

        modules-left = ["clock#date" "mpris"];
        modules-center = ["sway/workspaces"];
        modules-right = ["cpu" "temperature" "memory" "disk" "network" "pulseaudio" "tray" "clock#time"];
        fixed-center = true;

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "󰖟";
            "3" = "󰍥";
            "4" = "󰇰";
            "5" = "";
            "6" = "󱔘";
            "7" = "";
            "8" = "󱜹";
            "10" = "";
            "default" = "";
          };
        };
        "clock#date" = {
          format = "󰸗 {:%A, %B %d %Y}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            week-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
          };
        };
        "clock#time" = {
          format = "󱑃 {:%I:%M %p}";
        };
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            default = ["" "󰖀" "󰕾"];
          };
          on-click = "pamixer -t";
          on-scroll-up = "pamixer -i 1";
          on-scroll-down = "pamixer -d 1";
          on-click-right = "exec pavucontrol";
          tooltip-format = "{volume}%";
        };

        "network" = {
          interface = "enp*";
          format-wifi = "<small>{bandwidthDownBytes}</small> {icon}";
          min-length = 10;
          max-length = 40;
          format-ethernet = "󰈀 {bandwidthDownBytes} {bandwidthUpBytes}";
          format-disconnected = "󰲛 {ifname} disconnected";
          tooltip-format-ethernet = "󰈀 {ifname}\n󰩠\t{ipaddr}/{cidr}\n  \t{bandwidthDownBits}\n \t{bandwidthUpBits}";
          interval = 3;
          on-click-right = "alacritty -e nmtui";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };

        "disk" = {
          path = "/";
          interval = "30";
          format = "󰋊 {percentage_used}%";
          on-click-right = "alacritty -e gdu /";
          unit = "GB";
        };

        "memory" = {
          interval = "15";
          format = " {percentage}% ";
          unit = "GB";
          tooltip-format = "ram: \t{used} GiB out of {total} GiB\nswap: \t{swapUsed} GiB out of {swapTotal} GiB";
        };

        "temmperature" = {
        };

        "cpu" = {
          interval = "3";
          format = "󰻠 {usage}% (@ {avg_frequency}Ghz)";
          on-click-right = "alacritty -e btm";
        };

        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          interval = 10;
          dynamic-len = 50;
          player-icons = {
            default = "▶";
            mpv = "🎵";
            brave = "󰊯";
          };
          status-icons = {
            paused = "⏸";
          };
          # ignored-players = [ "firefox" ];  # Uncomment this line if you want to ignore specific players
        };
      }
    ];
    style = ''
      * {
         font-family: "Material Design Icons", "RobotoMono Nerd Font Mono";
         font-size: 16px;
         border: none;
      }

      window#waybar {
         background-color: rgba(0, 0, 0, 0); /* fully transparent */
      }

      #clock.date
       {
         background-color:${surface};
         color:${love};
         padding-left: 10px;
         padding-right: 10px;
         margin-left: 11px;
         border-radius: 10px;
         border: 4px solid ${muted};
      }

      #clock.time {
         background-color:${surface};
         color:${gold};
         padding-left: 10px;
         padding-right: 10px;
         margin-right: 11px;
         border-radius: 10px;
         border: 4px solid ${muted};
      }

      #workspaces {
         background-color:${surface};
         color:${love};
         margin-left: 0px;
         border-radius: 10px;
         border: 4px solid ${muted};
      }

      #workspaces button {
         background-color: transparent;
         margin: 0px;
         border: none;
         padding: 0px;
         padding-right: 5px;
         color: ${text};
      }

      #workspaces label {
        font-family: "JetbrainsMono";
        font-size: 20px;
        font-weight: normal;
      }

      #workspaces button.focused {
         background-color: ${highlightHigh};
         border-radius: 0px;
      }

      #workspaces button.focused label {
        font-weight: bold;
      }

      #cpu,
      #temperature,
      #disk,
      #memory,
      #network,
      #pulseaudio,
      #mpris,
      #tray {
         padding-right: 10px;
         padding-left: 10px;
         background-color:${surface};
         border-radius: 10px;
         margin-right: 10px;
         border: 4px solid ${muted};
      }

      #pulseaudio {
         color: ${foam};
         font-size: 22px;
      }

      #pulseaudio.muted {
         color: ${love};
         font-size: 22px;
      }

      #network {
         color:${iris};
      }

      #network.disconnected {
         color:${love}
      }

      #disk{
        color:${gold};
      }

      #temperature{
        color:${rose}
      }

      #temperature.critical{
        color:${love}
      }

      #cpu{
        color:${rose}
      }

      #memory{
        color:${rose_light}
      }

      #mpris{
        margin-left: 10px;
        color: ${foam_light}
      }

      #mpris.paused{
          font-style: italic;
          color: ${text_dark}
      }
    '';
  };
}
