{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  rose-pine-wallpapers = pkgs.callPackage ../../home/wallpapers.nix {} + "/field.jpg";
in {
  options.machine.x11.enable = lib.mkEnableOption "enables x11, i3 and desktop packages for this machine";
  options.machine.x11.dpi = lib.mkOption {
    type = lib.types.int;
    default = 96;
    description = "default dpi to be used for X11";
  };

  config = lib.mkIf config.machine.x11.enable {
    services = {
      #displayManager.autoLogin.enable = true;
      #displayManager.autoLogin.user = "${userDetails.userName}";
      displayManager.defaultSession = "none+i3";
      xserver = {
        displayManager.startx.enable = true;
        dpi = config.machine.x11.dpi;
        enable = true;
        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [
            xsecurelock
            xorg.libxcvt
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
            flameshot
            evince
            foliate
            inkscape-with-extensions
            i3lock
            xautolock
            xss-lock
            libreoffice
            xorg.xdpyinfo
          ];
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
      seahorse.enable = true;
      dconf.enable = true;
    };
  };
}
