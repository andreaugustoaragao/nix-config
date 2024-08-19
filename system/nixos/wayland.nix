{
  config,
  pkgs,
  userDetails,
  desktopDetails,
  ...
}: let
  wallpaper = pkgs.callPackage ../../home/wallpapers.nix {} + "/field.jpg";
in {
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };
  programs.hyprland.enable = true;

  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
  };
  environment.systemPackages = [
    (
      pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Roboto Medium";
        fontSize = "12";
        #background = wallpaper;
        loginBackground = false;
      }
    )
  ];
  services = {
    displayManager.defaultSession = "sway";
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      wayland.enable = false;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
      settings = {
        Theme = {
          CursorTheme = "bibata-cursors";
          CursorSize = 48;
          EnableAvatars = true;
          Background = wallpaper;
        };
      };
    };
    xserver = {
      dpi = desktopDetails.dpi;
      enable = true;
      displayManager = {
        gdm = {
          enable = false;
          wayland = false;
        };
        lightdm.enable = false;
        lightdm.greeters.lomiri.enable = false;
        lightdm.greeters.slick.enable = false;
        lightdm.greeters.slick.cursorTheme.size = 48;
        lightdm.greeters.slick.cursorTheme.package = pkgs.bibata-cursors;
        lightdm.greeters.slick.cursorTheme.name = "Bibata-Modern-Classic";
        lightdm.greeters.slick.draw-user-backgrounds = true;
        lightdm.background = wallpaper;
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
    dbus = {
      enable = true;
      packages = with pkgs; [dconf];
    };
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
