{pkgs, ...}: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
      size = "48x48";
    };
    settings = {
      global = {
        width = 450;
        height = 600;
        offset = "10x50";
        origin = "top-right";
        layer = "overlay";
        browser = "brave --new-tab";
        dmenu = "${pkgs.rofi}/bin/rofi -show run";
        follow = "mouse";
        font = "Roboto Mono Regular 14";
        format = "<b>%a</b>\\n%s\\n%b";
        frame_width = 1;
        corner_radius = 15;
        horizontal_padding = 5;
        padding = 5;
        icon_position = "left";
        line_height = 0;
        markup = "full";
        #separator_color = "frame";
        separator_color = "auto";
        separator_height = 2;
        transparency = 9;
        word_wrap = true;
        max_icon_size = 256;
        enable_recursive_icon_lookup = true;
        idle_threshold = 120;
        stack_duplicates = true;
        show_indicators = true;
        progress_bar = true;
        icon_theme = "rose-pine";
      };

      urgency_low = {
        background = "#6e6a81";
        foreground = "#e0def4";
        frame_color = "#5b96b2";
        timeout = 10;
      };

      urgency_normal = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#5b96b2";
        timeout = 15;
      };

      urgency_critical = {
        background = "#eb6f92";
        foreground = "#e0def4";
        frame_color = "#5b96b2";
        timeout = 0;
      };
    };
  };
}
