{
  gtk-nix,
  config,
  pkgs,
  lib,
  ...
}: {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gtk/settings/file-chooser" = {
        show-type-column = true;
        sidebar-width = 152;
        date-format = "with-time";
        location-mode = "path-bar";
        show-hidden = true;
        show-size-column = true;
        sort-column = "modified";
        sort-directories-first = true;
        sort-order = "ascending";
        type-format = "category";
        #window-position="(462,304)";
        #window-size="(799, 491)";
      };
    };
  };
  # gtk's theme settings, generate files:
  #   1. ~/.gtkrc-2.0
  #   2. ~/.config/gtk-3.0/settings.ini
  #   3. ~/.config/gtk-4.0/settings.ini
  gtk = {
    enable = true;

    font = {
      name = "Roboto Medium";
      package = pkgs.roboto;
      size = 13;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      #name = "Papirus-Dark";
      #package = pkgs.papirus-icon-theme;
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    theme = {
      # https://github.com/catppuccin/gtk
      #name = "rose-pine";
      #package = pkgs.rose-pine-gtk-theme;

      name = "catppuccin-mocha-pink-standard";
      package = pkgs.catppuccin-gtk.override {
        # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/data/themes/catppuccin-gtk/default.nix
        accents = ["pink"];
        size = "standard";
        variant = "mocha";
      };
    };

    gtk3.bookmarks = [
      "file:///${config.home.homeDirectory}/projects"
      "file:///${config.home.homeDirectory}/screenshots"
      "file:///${config.home.homeDirectory}/downloads"
    ];

    gtk3.extraConfig = {
      gtk-decoration-layout = "menu:close";
    };
    gtk4.extraConfig = {
      gtk-decoration-layout = ":close";
    };
  };

  # home.sessionVariables.GTK_THEME = config.gtk.theme.name;
  services.xsettingsd = {
    enable = false;
    settings = {
      "Gtk/DecorationLayout" = ":";
      "Net/EnableInputFeedbackSounds" = 0;
      "Net/ThemeName" = "${config.gtk.theme.name}";
    };
  };
}
