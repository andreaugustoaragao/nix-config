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
        dpi-x = 0;
        dpi-y = 0;
        bottom = false;
        fixed-center = true;
        override-redirect = true;
        #        width = "99%";
        #        offset-x = "32";
        offset-y = "0";
        height = 45;
        #radius = 25;
        #offset-x = 150;
        #offset-y = 150;
        background = "${background-transparent}";
        foreground = "${foreground}";
        line-size = "2pt";
        border-size = "0pt";
        border-color = "#00000000";
        #padding = 10;
        #padding-left = 1;
        padding-right = 0;
        padding-left = 0;

        module-margin-left = 0;
        module-margin-right = 0;

        separator = " ";
        separator-foreground = "${disabled}";
        # font-0 = "FiraCode Nerd Font:size=12;2;style=bold";
        font-0 = "JetbrainsMono Nerd Font:size=12:weight=bold;4";
        font-1 = "JetbrainsMono Nerd Font:size=12:weight=bold;4";
        font-2 = "JetbrainsMono Nerd Font Mono:size=20:weight=bold;5";
        font-3 = "JetbrainsMono Nerd Font Mono:size=19:weight=bold;5";

        modules-left = "xworkspaces xwindow";
        modules-right = "cpu temperature memory filesystem network avaya battery date tray notifications powermenu";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        wm-restack = "i3";
        enable-ipc = true;

        #tray-position = "right";
        #tray-maxsize = 20;
        #tray-padding = 10;
        #tray-offset-x = 0;
      };

      "module/tray" = {
        type = "internal/tray";
        tray-size = "55%";
        tray-spacing = 10;
        #format-margin = "8px";
        format-background = background-alt;
        format-underline = quaternary;
      };

      "module/os" = {
        type = "custom/text";
        format = "<label>";
        label = "󰀻";
        label-font = "3";
        click-left = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
      };

      "module/xworkspaces" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        ws-icon-0 = "1;  "; # terminal
        ws-icon-1 = "2; 󰖟 "; # browser
        ws-icon-2 = "3; 󰊻 "; # teams
        ws-icon-3 = "4; 󰴢 "; # outlocker
        ws-icon-4 = "5;  "; # idea
        ws-icon-5 = "6;  "; # rocket chat
        ws-icon-6 = "7; 󱔘 "; # documents: pdfs and books and images and powerpoint and excel
        ws-icon-7 = "8;  "; # music
        ws-icon-8 = "9; 󱜸 "; # chat gpt
        ws-icon-default = "  ";

        label-focused = "%icon%";
        label-focused-padding = 0;
        label-focused-underline = "${primary}";
        label-focused-background = "${background-alt}";
        label-focused-font = "3";

        label-unfocused = "%icon%";
        label-unfocused-font = 3;
        label-unfocused-padding = 0;

        label-visible = "%icon%";
        label-visible-font = 3;
        #       label-visible-padding = 1;

        label-urgent = "%icon%";
        #      label-urgent-padding = 1;
        label-urgent-background = "${alert}";
        label-urgent-font = 3;
        #label-active-background = "${background-alt}";
        #label-active-underline= "${primary}";
        #label-active-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title%";
        label-maxlen = 50;
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%a %b %d %l:%M %p";
        label = "%date%";
        label-padding-x = 0;
        #label-foreground = "${primary}";
        label-background = background-alt;
        label-underline = quaternary;
      };

      "module/memory" = {
        type = "internal/memory";

        interval = 3;

        format = "%{T4}󰍛  %{T-}<label>";
        format-background = background-alt;
        format-underline = quaternary;
        #format-foreground = secondary;
        # format-padding = 1;

        #label = "%gb_used%/%gb_total%";
        label = "%gb_used%(%percentage_used%%)";
        #format-underline = tertiary;
        label-font = 2;
      };

      "module/cpu" = {
        type = "internal/cpu";

        interval = "1";

        format = "%{T4}󰻠 %{T-}<label>";
        # jformat-underline = quaternary;

        #format-foreground = quaternary;
        format-background = background-alt;
        format-underline = quaternary;
        #format-padding = 1;

        label = "%percentage:2%%";
        #label-underling = secondary;
        label-font = 2;
      };

      "module/battery" = {
        type = "internal/battery";
        full-at = 101; # to disable it
        battery = "BAT0"; # TODO: Better way to fill this
        adapter = "AC0";

        poll-interval = 2;

        label-full = "  100%";
        format-full-padding = 0;
        #format-full-foreground = secondary;
        #format-full-background = primary;

        format-charging = " <animation-charging> <label-charging>";
        format-charging-padding = 0;
        #format-charging-foreground = secondary;
        #format-charging-background = primary;
        label-charging = " %percentage%%";
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = 500;

        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-padding = 0;
        # format-discharging-foreground = secondary;
        # format-discharging-background = primary;
        label-discharging = " %percentage%%";
        ramp-capacity-0 = "";
        ramp-capacity-0-foreground = alert;
        ramp-capacity-1 = "";
        ramp-capacity-1-foreground = alert;
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
      };

      "module/powermenu" = {
        type = "custom/text";

        format-padding = 1;

        label = " ";
        click-left = "~/.local/bin/powermenu.sh";
        label-background = background-alt;
        label-underline = quaternary;
      };

      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        fixed-values = false;
        format-mounted = "<label-mounted>";
        label-mounted = "%{T4}󰋊 %{T-}%used%(%percentage_used%%)";
        label-mounted-font = 2;
        label-mounted-background = background-alt;
        label-mounted-underline = quaternary;
      };

      "module/network" = {
        type = "internal/network";
        # interface = "enp4s0";
        interface-type = "wired";
        interval = "3.0";
        label-connected = "%ifname%: %{T4}󰛴 %{T-}%downspeed% %{T4}󰛶 %{T-}%upspeed%";
        label-connected-font = 2;
        label-connected-underline = quaternary;
        label-connected-background = background-alt;

        label-disconnected = "󰲛 OFFLINE";
        label-disconnected-foreground = alert;
      };

      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };

      "module/temperature" = {
        type = "internal/temperature";
        interval = 1;
        hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon4/temp2_input";
        label = " %temperature-c%";
        label-background = background-alt;
        label-underline = quaternary;
      };

      "module/notifications" = {
        type = "custom/script";
        exec = "~/.local/bin/notifications.sh";
        tail = false;
        interval = 1;
        format = "<label>";
        format-padding = 0;
        label = "%output%";
        label-font = 2;
        label-background = background-alt;
        label-underline = quaternary;
        click-left = "~/.local/bin/toggle-notifications.sh";
      };

      "module/avaya" = {
        type = "custom/script";
        exec = "~/.local/bin/connected-to-avaya.sh";
        tail = false;
        interval = 5;
        format = "<label>";
        label = "%output%";
        label-font = 2;
      };
    };
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
}
