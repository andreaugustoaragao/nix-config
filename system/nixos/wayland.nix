{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.machine.wayland.enable = lib.mkEnableOption "enables sway and desktop packages for this machine";
  config = lib.mkIf config.machine.wayland.enable {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export QT_AUTO_SCREEN_SCALE_FACTOR=0
        export QT_SCALE_FACTOR=1
        export GDK_SCALE=1
        export GDK_DPI_SCALE=1
        export MOZ_ENABLE_WAYLAND=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        #export SWAYSOCK=(ls /run/user/1000/sway-ipc.* | head -n 1)
        export NIXOS_OZONE_WL=1
      '';
      xwayland.enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        rofi
        brightnessctl
        sway-contrib.grimshot
        wlr-randr
        wdisplays
        qutebrowser
        qt5.qtwayland
        glxinfo
        pavucontrol
        qutebrowser
        libreoffice
        zathura
        neovide
        font-manager
        evince
      ];
    };
    security.pam.services.swaylock = {};
    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    };

    services = {
      gnome.gnome-keyring.enable = true;
      dbus = {
        enable = true;
      };
      gvfs.enable = true;
      tumbler.enable = true;
    };

    security.pam.services.greetd.enableGnomeKeyring = true;

    programs = {
      dconf.enable = true;
      foot = {
        enable = true;
        theme = "paper-color-dark";
        enableFishIntegration = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:size=10";
            shell = "${pkgs.fish}/bin/fish";
            term = "xterm-256color";
            selection-target = "both";
            pad = "5x5 center";
          };
          colors = {
            alpha = 0.92;
          };
          mouse = {
            hide-when-typing = true;
          };
          scrollback = {
            lines = 100000;
          };
          tweak = {
            font-monospace-warn = false;
          };
        };
      };
    };
  };
}
