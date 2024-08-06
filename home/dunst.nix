{pkgs, ...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "12x30";
        origin = "top-right";

        browser = "${pkgs.chromium}/bin/chromium -new-tab";
        #dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
        follow = "mouse";
        font = "Roboto Mono Regular 10";
        format = "<b>%s</b>\\n%b";
        frame_width = 1;
        horizontal_padding = 8;
        icon_position = "left";
        line_height = 0;
        markup = "full";
        padding = 8;
        #separator_color = "frame";
        separator_color = "auto";
        separator_height = 2;
        transparency = 10;
        word_wrap = true;
        icon_theme = "rose-pine";
        enable_recursive_icon_lookup = true;
        idle_threshold = 120;
        stack_duplicates = true;
        show_indicators = true;
      };

      urgency_low = {
        background = "#6e6a81";
        foreground = "#e0def4";
        frame_color = "#c4a7e7";
        timeout = 10;
      };

      urgency_normal = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#c4a7e7";
        timeout = 15;
      };

      urgency_critical = {
        background = "#eb6f92";
        foreground = "#e0def4";
        frame_color = "#c4a7e7";
        timeout = 0;
      };
    };
  };
}
