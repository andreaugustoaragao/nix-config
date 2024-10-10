{
  stdenv,
  pkgs,
  ...
}: let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        padding = {
          y = 5;
          x = 5;
        };
        opacity = 0.90;
        dynamic_title = true;
        decorations = "Buttonless";
        #dpi = 192;
      };

      font = {
        normal.family = "JetbrainsMono Nerd Font";
        normal.style =
          if isLinux
          then "Regular"
          else "Regular";

        bold.style =
          if isLinux
          then "Bold"
          else "Bold";
        italic.style =
          if isLinux
          then "Italic"
          else "Italic";
        bold_italic.style =
          if isLinux
          then "Bold Italic"
          else "Bold Italic";
        size =
          if isLinux
          then 10
          else 12;
      };

      shell = {
        #program = "${pkgs.tmux}/bin/tmux";
        #args = [
        #  "new-session"
        #  "-s"
        #  "default"
        #  "-A"
        #];
        program = "${pkgs.fish}/bin/fish";
      };

      colors = {
        transparent_background_colors = false;
        primary = {
          foreground = "#e0def4";
          background = "#191724";
          dim_foreground = "#908caa";
          bright_foreground = "#e0def4";

          #foreground = "#e0def4";
          #background = "#191724";
          #dim_foreground = "#908caa";
          #bright_foreground = "#e0def4";

          #background = "#000000";
          #foreground = "0xEBEBEB";
        };
        cursor = {
          #text = "#FF261E";
          #cursor = "#FF261E";
          cursor = "#eb6f92";
          text = "#eb6f92";
          #text = "#e0def4";
          #cursor = "#524f67";
        };
        vi_mode_cursor = {
          text = "#e0def4";
          cursor = "#524f67";
        };
        search.matches = {
          foreground = "#908caa";
          background = "#26233a";
        };
        search.focused_match = {
          foreground = "#191724";
          background = "#ebbcba";
        };
        hints.start = {
          foreground = "#908caa";
          background = "#1f1d2e";
        };
        line_indicator = {
          foreground = "None";
          background = "None";
        };
        footer_bar = {
          foreground = "#e0def4";
          background = "#1f1d2e";
        };
        selection = {
          text = "#e0def4";
          background = "#403d52";
        };

        normal = {
          #black = "#0D0D0D";
          #red = "#FF301B";
          #green = "#A0E521";
          #yellow = "#FFC620";
          #blue = "#178AD1";
          #magenta = "#9f7df5";
          #cyan = "#21DEEF";
          #white = "#EBEBEB";
          black = "#26233a";
          red = "#eb6f92";
          green = "#31748f";
          yellow = "#f6c177";
          blue = "#9ccfd8";
          magenta = "#c4a7e7";
          cyan = "#ebbcba";
          white = "#e0def4";
        };
        bright = {
          #black = "#6D7070";
          #red = "#FF4352";
          #green = "#B8E466";
          #yellow = "#FFD750";
          #blue = "#1BA6FA";
          #magenta = "#B978EA";
          #cyan = "#73FBF1";
          #white = "#FEFEF8";
          black = "#6e6a86";
          red = "#eb6f92";
          green = "#31748f";
          yellow = "#f6c177";
          blue = "#9ccfd8";
          magenta = "#c4a7e7";
          cyan = "#ebbcba";
          white = "#e0def4";
        };
        dim = {
          black = "#6e6a86";
          red = "#eb6f92";
          green = "#31748f";
          yellow = "#f6c177";
          blue = "#9ccfd8";
          magenta = "#c4a7e7";
          cyan = "#ebbcba";
          white = "#e0def4";
        };
      };

      keyboard.bindings = [
        {
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    #font.name = "FiraCodeNFM-Reg";
    #font.name = "family='Menlo'";
    #font.name = "JetBrainsMonoNFM-Regular";
    font.name = "FiraCodeRoman-Regular";
    font.size = 12;
    settings = {
      confirm_os_window_close = 0;
      mouse_hide_wait = "1.0";
      dynamic_background_opacity = true;
      scrollback_lines = 100000;
      enable_audio_bell = false;
      update_check_interval = 0; #no phone home
      #hide_window_decorations = true;
      active_border_color = "#FFFFFF";
      hide_window_decorations = "titlebar-only";
      macos_show_window_title_in = "none";
      shell = "${pkgs.fish}/bin/fish";
      background_opacity = 0.80;
    };
    shellIntegration.enableFishIntegration = true;
    themeFile = "GitHub_Dark";
  };
}
