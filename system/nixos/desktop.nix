{
  config,
  pkgs,
  userDetails,
  desktopDetails,
  ...
}: let
  rose-pine-wallpapers = pkgs.callPackage ../../home/wallpapers.nix {} + "/field.jpg";
in {
  services = {
    #displayManager.autoLogin.enable = true;
    #displayManager.autoLogin.user = "${userDetails.userName}";
    displayManager.defaultSession = "none+i3";
    xserver = {
      dpi = desktopDetails.dpi;
      enable = true;
      displayManager = {
        lightdm.enable = true;
        lightdm.greeters.lomiri.enable = false;
        lightdm.greeters.slick.enable = true;
        lightdm.greeters.slick.cursorTheme.size = 48;
        lightdm.greeters.slick.cursorTheme.package = pkgs.bibata-cursors;
        lightdm.greeters.slick.cursorTheme.name = "Bibata-Modern-Classic";
        lightdm.greeters.slick.draw-user-backgrounds = true;
        lightdm.background = rose-pine-wallpapers;
        lightdm.greeters.slick.theme = {
          name = "catppuccin-mocha-pink-standard";
          package = pkgs.catppuccin-gtk.override {
            # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/data/themes/catppuccin-gtk/default.nix
            accents = ["pink"];
            size = "standard";
            variant = "mocha";
          };
        };
        lightdm.greeters.slick.iconTheme = {
          #name = "Papirus-Dark";
          #package = pkgs.papirus-icon-theme;
          name = "rose-pine";
          package = pkgs.rose-pine-icon-theme;
        };
        lightdm.greeters.enso.enable = false;
        lightdm.greeters.enso.blur = false;
        #        lightdm.greeters.enso.theme.package = pkgs.rose-pine-gtk-theme;
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          rofi
          pavucontrol
          xcolor
          xclip
          xdo
          xdotool
          xsel
          firefox
          font-manager
          neovide
          pavucontrol
          obsidian
          zathura
          #flameshot
          evince
          foliate
          inkscape-with-extensions
          i3lock
          xautolock
          xss-lock
          libreoffice
        ];
        extraSessionCommands = ''
          xrandr --output Virtual-1 --auto
        '';
      };

      xkb.layout = "us";
    };
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = false;
    touchpad.scrollMethod = "twofinger";
    touchpad.disableWhileTyping = false;
    touchpad.clickMethod = "clickfinger";
  };
  #programs.xss-lock.enable = true;

  #programs.xss-lock.lockerCommand = "export XSECURELOCK_SAVER=saver_xscreensaver; ${pkgs.xsecurelock}/bin/xsecurelock";
  #programs.xss-lock.extraOptions = ["-n ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer" "-l"];
  security.pam.services.lightdm.enableGnomeKeyring = true;
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs; [
        xfce.thunar-archive-plugin
        xfce.thunar-volman
        xfce.thunar-media-tags-plugin
        file-roller
      ];
    };
    dconf.enable = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-kde
  #   ];
  # };
}
