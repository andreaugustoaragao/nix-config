{
  pkgs,
  desktopDetails,
  config,
  lib,
  ...
}: let
  rose-pine-wallpapers = pkgs.callPackage ./wallpapers.nix {} + "/rocks.jpg";
in {
  imports = [
    ./rofi.nix
    ./polybar.nix
    ./picom.nix
    ./redshift.nix
    ./dunst.nix
  ];
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = rec {
      modifier = "Mod1";
      bars = [];
      #https://github.com/nix-community/home-manager/blob/master/modules/services/window-managers/i3-sway/lib/options.nix
      colors = {
        focused = {
          background = "#191724";
          #border = "#c4a7e7";
          border = "#9ccfd8";
          text = "#e0def4";
          indicator = "#eb6f92";
          #childBorder = "#c4a7e7";
          childBorder = "#5b96b2";
        };
        "background" = "#191724";
      };
      window.border = 4;
      window.titlebar = false;
      gaps = {
        inner = 5;
        outer = 5;
        top = 45;
        #left = 5;
        #right = 5;
        #bottom = 5;
      };
      #gaps.smartBorders = "off";
      window.hideEdgeBorders = "smart";
      defaultWorkspace = "workspace number 1";
      floating.criteria = [{class = "pavucontrol";} {class = "1Password";}];
      floating.titlebar = false;
      fonts = {
        names = ["RobotoMono"];
        style = "Bold";
        size = 12.0;
      };
      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
        "${modifier}+Return" = " exec ${pkgs.alacritty}/bin/alacritty msg create-window || ${pkgs.alacritty}/bin/alacritty";
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+b" = "split h";
        "${modifier}+Shift+4" = "exec flameshot gui";
        "${modifier}+Shift+b" = "exec brave --new-tab httos://www.google.com";
        "${modifier}+Shift+p" = "exec sh -c ~/.local/bin/powermenu.sh";
      };
      assigns = {
        "1" = [
          {
            class = "Alacritty";
            instance = "default-tmux";
          }
        ];
        "2" = [
          {class = "^firefox$";}
          {
            instance = "chromium-browser";
            class = "Chromium-browser";
          }
          {
            instance = "brave-browser";
            class = "Brave-browser";
          }
        ];
        "3" = [
          {
            instance = "teams.microsoft.com";
            class = "Brave-browser";
          }
          {
            instance = "teams-for-linux";
            class = "teams-for-linux";
          }
        ];
        "4" = [
          {
            instance = "outlook.office.com";
            class = "Brave-browser";
          }
          {
            instance = "mail.google.com";
            class = "Brave-browser";
          }
        ];
        "5" = [{class = "jetbrains-goland";} {class = "jetbrains-idea";}];
        "8" = [
          {
            instance = "music.youtube.com";
            class = "Brave-browser";
          }
          {
            instance = "youtube.com";
            class = "Brave-browser";
          }
        ];
        "9" = [
          {
            instance = "chat.openai.com";
            class = "Brave-browser";
          }
        ];
        "10" = [
          {
            instance = "x.com";
            class = "Brave-browser";
          }
          {
            instance = "reddit.com";
            class = "Brave-browser";
          }
          {
            instance = "web.whatsapp.com";
            class = "Brave-browser";
          }
        ];
      };
      focus.newWindow = "focus";
      startup = [
        {
          command = "polybar-check";
          always = true;
          notification = false;
        }
        {
          command = "xset dpms 1800 1800 1800";
          always = false;
          notification = false;
        }

        {
          command = "xset s 600";
          always = false;
          notification = false;
        }
        {
          command = "xss-lock -n ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer -l -- ${pkgs.xsecurelock}/bin/xsecurelock";
          always = false;
        }
        /*
        {
          command = "xautolock -time 10 -locker 'i3lock -c 000000' -detectsleep";
          always = false;
          notification = false;
        }
        */
        {
          command = "exec i3-msg workspace 1";
          always = false;
          notification = false;
        }
        {
          command = "exec spice-vdagent";
          always = false;
          notification = true;
        }
        {
          command = "${pkgs.feh}/bin/feh --randomize --bg-fill ${rose-pine-wallpapers}";
          always = false;
          notification = false;
        }
        {
          command = "${pkgs.alacritty}/bin/alacritty --class Alacritty,default-tmux -e 'tmux' new-session -s default -A";
          always = false;
          notification = true;
        }
        {
          command = "1password --silent";
          always = false;
          notification = true;
        }
        {
          command = "eww kill && eww daemon";
          always = true;
          notification = true;
        }
      ];
    };
    extraConfig = ''
      # Center a specific dialog horizontally and position it 45px from the top
      for_window [class="^my-calendar-class$"] floating enable
    '';
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "polybar-check" ''
      #!/usr/bin/env bash
      killall -9 ."polybar-wrappe"
      #jif pgrep -x ".polybar-wrappe" > /dev/null; then
      #    echo "Polybar is running. Reloading configuration..."
          # Reload Polybar configuration
      #     pkill -USR1 -x .polybar-wrappe
      # else
      #    echo "Polybar is not running. Starting Polybar..."
          # Start Polybar (adjust "mybar" to your configuration name)

          polybar -q -r top &
      #fi
    '')
  ];
}
