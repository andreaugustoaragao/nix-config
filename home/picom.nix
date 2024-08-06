{pkgs, ...}: {
  services.pasystray.enable = true;
  services.picom = {
    enable = true;

    settings = {
      backend = "glx";
      vSync = true;
      fade = true;
    };

    /*
      settings = {
        corner-radius = 25;
        #corner-radius-exclude = [ "window_class = 'Polybar'" ];
        blur-method = "dual_kawase";
        blur-strength = 5;
        blur = true;
        detect-client-opacity = true;
        shadow-exclude = [
          "! name~=''"
          "name = 'Notification'"
          "class_g ?= 'Notify-osd'"
          "_GTK_FRAME_EXTENTS@:c"
          "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
          "class_g = 'Dunst'"
        ];
        #      blur-background-fixed = false;
        #     blue-background-exclude = [
        #       "window_type = 'dock'"
        #       "window_type = 'desktop'"
        #     ];
        #    detect-rounded-corners = true;
        #     blur = true;
        #     blurExclude = [ "window_type = 'dock'" "window_type = 'desktop'" ];
      };
      # backend = "glx";
      # vSync = true;
      #inactiveOpacity = 0.93;
      #package = pkgs.callPackage ../packages/compton-unstable.nix { };

      fade = true;
      fadeDelta = 5;

      shadow = true;
      shadowOffsets = [(-7) (-7)];
      shadowOpacity = 0.7;
      shadowExclude = ["window_type *= 'normal' && ! name ~= 'polybar'"];
      #activeOpacity = 1;
      #inactiveOpacity = 0.8;
      #menuOpacity = 0.8;

      backend = "glx";
      vSync = true;
      #https://github.com/yshui/picom/issues/1226
      wintypes = {
        tooltip = {
          fade = true;
          shadow = false;
          focus = true;
        };
        dropdown_menu = {
          fade = true;
          shadow = false;
          focus = true;
        };
        popup_menu = {
          fade = true;
          shadow = false;
          focus = true;
        };
        utility = {
          fade = true;
          shadow = false;
          focus = true;
        };
        menu = {shadow = false;};
        dock = {shadow = false;};
        dnd = {shadow = false;};
      };
    };
    */
  };
}
