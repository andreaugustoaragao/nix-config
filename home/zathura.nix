{
  pkgs,
  config,
  ...
}: {
  programs.zathura = {
    enable = true;
    options = {
      # recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.9)";

      #font = "Inter 12";
      selection-notification = true;

      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      zoom-min = "10";
      guioptions = "";
      show-recent = 10;
    };

    #extraConfig = "include catppuccin-mocha";
  };

  xdg.configFile = {
    "zathura/catppuccin-mocha".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/zathura/main/src/catppuccin-mocha";
      hash = "sha256-POxMpm77Pd0qywy/jYzZBXF/uAKHSQ0hwtXD4wl8S2Q=";
    };
  };
}
