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

  transparent_background = "#00000000"; # Fully transparent background
  transparent_foreground = "#ffffffff"; # Fully opaque foreground (text color)
  __curDir = builtins.toString ./.;
in {
  services.polybar = {
    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      pulseSupport = true;
    };
    enable = true;
    script = ''if [ "$XDG_SESSION_TYPE" = "x11" ]; then polybar-check ; fi'';
    config = {
      "bar/top" = {
        bottom = false;
        top = true;
        width = "100%:-22px";
        height = 40;
        offset-x = "11px";
        offset-y = "5px";
        override-redirect = true;
        font-0 = "RobotoMono Nerd Font Mono:size=12:weight=regular;2";
        font-1 = "RobotoMono Nerd Font Mono:size=18:weight=regular;4";
        font-2 = "Weather Icons:size=12;0";
        modules-left = "launcher date weather";
        modules-center = "xworkspaces";
        modules-right = "cpu temperature memory filesystem network volume notifications tray time powermenu";
        background = transparent_background;
        foreground = transparent_foreground;
        line-size = 4;
        module-margin-right = "10px";
        wm-restack = "i3";
        cursor-click = "pointer";
      };

      "module/base" = {
        format-background = surface;
        format-underline = muted;
        format-overline = muted;
        format-padding = "15px";
        label-font = 1;
      };

      "module/xworkspaces" = {
        "inherit" = "module/base";

        type = "internal/i3";
        format = "<label-state> <label-mode>";
        format-padding = 0;

        ws-icon-0 = "1;  "; # terminal
        ws-icon-1 = "2; 󰖟 "; # browser
        ws-icon-2 = "3; 󰭹 "; # teams
        ws-icon-3 = "4; 󰇮 "; # email
        ws-icon-4 = "5;  "; # ide
        ws-icon-5 = "6; 󱔘 "; # documents: pdfs and books and images and powerpoint and excel
        ws-icon-6 = "7;  "; # youtube
        ws-icon-7 = "8; 󱜸 "; # chat gpt
        ws-icon-default = "  ";

        label-focused = "%icon%";
        label-focused-overline = foam;
        label-focused-underline = foam;
        label-focused-background = highlightHigh;
        label-focused-font = "2";

        label-unfocused = "%icon%";
        label-unfocused-font = 2;

        label-unfocused-overline = muted;
        label-unfocused-background = base;
        label-unfocused-underline = muted;

        label-visible = "%icon%";
        label-visible-font = 2;
        label-visible-background = base;
        label-visible-overline = muted;
        label-visible-underline = muted;

        label-urgent = "%icon%";
        label-urgent-background = love;
        label-urgent-font = 2;
        label-urgent-underline = muted;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        "inherit" = "module/base";
        format-padding = "5px";
        label = "%title%";
        label-maxlen = 150;
      };

      "module/date" = {
        type = "internal/date";
        "inherit" = "module/base";
        interval = 60;
        #date = "%a %b %d %l:%M %p";
        date = "%A, %b %d";
        label = "%{T2}%{T-} %date%";
        format-foreground = love;
      };

      "module/time" = {
        type = "internal/date";
        "inherit" = "module/base";
        interval = 5;
        date = "%{T2}󰥔%{T-} %l:%M %p";
        label = "%date%";
        format-foreground = gold;
      };

      "module/weather" = {
        type = "custom/script";
        "inherit" = "module/base";
        exec = "~/.local/bin/weather.sh";
        tail = false;
        interval = 960;
        label = "%{A3:${pkgs.brave}/bin/brave --app=https\\://openweathermap.org/city/5576859:}%output%%{A}";
      };

      "module/volume" = {
        type = "internal/pulseaudio";
        "inherit" = "module/base";
        click-right = "${pkgs.pavucontrol}/bin/pavucontrol";

        format-volume = "<label-volume>";
        format-padding = "15px";

        label-muted = "%{T2}󰓄%{T-} muted";
        label-muted-foreground = muted;
        label-muted-background = base;
        label-muted-font = 1;
        label-muted-overline = muted;
        label-muted-underline = muted;
        label-muted-padding = "15px";

        label-volume = "%{T2}󰓃%{T-} %percentage%%";
        label-volume-foreground = foam;
        label-volume-background = base;
        label-volume-font = 1;
        label-volume-overline = muted;
        label-volume-underline = muted;
        label-volume-padding = "15px";

        ramp-volume-0 = "🔈";
        ramp-volume-1 = "🔉";
        ramp-volume-2 = "🔊";

        ramp-volume-font = 2;
      };

      "module/memory" = {
        type = "internal/memory";
        "inherit" = "module/base";
        interval = 3;
        format = "%{T2} %{T-}<label>";
        format-foreground = text;
        format-background = surface;
        label = "%percentage_used%%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        "inherit" = "module/base";
        interval = "3";
        format = "%{A3:${pkgs.alacritty}/bin/alacritty -e ${pkgs.bottom}/bin/btm:}%{T2}󰻠 %{T-}<label>%{A}";
        format-foreground = rose;
        label = "%percentage%%";
      };

      "module/temperature" = {
        type = "internal/temperature";
        "inherit" = "module/base";
        interval = 3;
        hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon4/temp2_input";
        format-foreground = rose;
        label = "%{T2}%{T-} %temperature-c%";
      };

      "module/filesystem" = {
        type = "internal/fs";
        "inherit" = "module/base";
        mount-0 = "/";
        fixed-values = false;
        format-mounted = "<label-mounted>";

        label-mounted = "%{A3:${pkgs.alacritty}/bin/alacritty -e ${pkgs.gdu}/bin/gdu /:}%{T2}󰋊 %{T-}%percentage_used%%%{A}";
        label-mounted-font = 1;
        label-mounted-foreground = gold;
        label-mounted-background = surface;
        label-mounted-overline = muted;
        label-mounted-underline = muted;
        label-mounted-padding = "15px";
        click-left = "${pkgs.gdu}/bin/gdu";
      };

      "module/network" = {
        type = "internal/network";
        "inherit" = "module/base";
        interface-type = "wired";
        interval = "3.0";
        label-connected = "%{T2}󰛴 %{T-}%downspeed% %{T2}󰛶 %{T-}%upspeed%";
        label-connected-font = 1;
        label-connected-underline = muted;
        label-connected-overline = muted;
        label-connected-background = surface;
        label-connected-foreground = iris;
        label-connected-padding = "15px";

        label-disconnected = "%{T2}󰲛 %{T-}OFFLINE";
        label-disconnected-foreground = love;
        label-disconnected-padding = "15px";
        label-disconnected-background = surface;
        label-disconnected-underline = muted;
        label-disconnected-overline = muted;
        label-disconnected-font = 1;
      };

      "module/tray" = {
        type = "internal/tray";
        tray-size = "55%";
        "inherit" = "module/base";
        tray-spacing = "15px";
        tray-background = surface;
      };

      "module/powermenu" = {
        type = "custom/text";
        "inherit" = "module/base";
        label = "";
        click-left = "~/.local/bin/powermenu.sh";
        label-font = 2;
      };

      "module/launcher" = {
        type = "custom/text";
        "inherit" = "module/base";
        label = "󰀻";
        click-left = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
        label-font = 2;
      };

      "module/notifications" = {
        type = "custom/script";
        "inherit" = "module/base";
        exec = "~/.local/bin/notifications.sh";
        tail = false;
        interval = 1;
        format = "<label>";
        label = "%output%";
        label-font = 2;
        click-left = "~/.local/bin/toggle-notifications.sh";
      };

      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };
    #h
    #h      "module/battery" = {
    #h        type = "internal/battery";
    #h        full-at = 101; # to disable it
    #h        battery = "BAT0"; # TODO: Better way to fill this
    #h        adapter = "AC0";
    #h
    #h        poll-interval = 2;
    #h
    #h        label-full = "  100%";
    #h        format-full-padding = 0;
    #h        #format-full-foreground = secondary;
    #h        #format-full-background = primary;
    #h
    #h        format-charging = " <animation-charging> <label-charging>";
    #h        format-charging-padding = 0;
    #h        #format-charging-foreground = secondary;
    #h        #format-charging-background = primary;
    #h        label-charging = " %percentage%%";
    #h        animation-charging-0 = "";
    #h        animation-charging-1 = "";
    #h        animation-charging-2 = "";
    #h        animation-charging-3 = "";
    #h        animation-charging-4 = "";
    #h        animation-charging-framerate = 500;
    #h
    #h        format-discharging = "<ramp-capacity> <label-discharging>";
    #h        format-discharging-padding = 0;
    #h        # format-discharging-foreground = secondary;
    #h        # format-discharging-background = primary;
    #h        label-discharging = " %percentage%%";
    #h        ramp-capacity-0 = "";
    #h        ramp-capacity-0-foreground = alert;
    #h        ramp-capacity-1 = "";
    #h        ramp-capacity-1-foreground = alert;
    #h        ramp-capacity-2 = "";
    #h        ramp-capacity-3 = "";
    #h        ramp-capacity-4 = "";
    #h      };
    #h
    #h      "module/avaya" = {
    #h        type = "custom/script";
    #h        exec = "~/.local/bin/connected-to-avaya.sh";
    #h        tail = false;
    #h        interval = 5;
    #h        format = "<label>";
    #h        label = "%output%";
    #h        label-font = 2;
    #h      };
    #h
    #h    };
  };

  home.file.".local/bin/notifications.sh" = {
    source = "${__curDir}/notifications.sh";
    executable = true;
  };

  home.file.".local/bin/connected-to-avaya.sh" = {
    source = "${__curDir}/connected-to-avaya.sh";
    executable = true;
  };

  home.file.".local/bin/toggle-notifications.sh" = {
    source = "${__curDir}/toggle-notifications.sh";
    executable = true;
  };

  home.file.".local/bin/powermenu.sh" = {
    source = "${__curDir}/powermenu.sh";
    executable = true;
  };

  home.file.".local/bin/powermenu.rasi" = {
    source = "${__curDir}/powermenu.rasi";
    executable = false;
  };

  home.file.".local/bin/weather.sh" = {
    source = "${__curDir}/weather.sh";
    executable = true;
  };
}
