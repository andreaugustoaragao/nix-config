{
  pkgs,
  lib,
  config,
  ...
}: {
  services.greetd = lib.mkIf (config.machine.role == "pc") {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --remember --asterisks --debug";
      };
    };
  };

  environment.etc."greetd/sway-config" = {
    enable = true;
    text = ''
      # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
      exec "regreet; swaymsg exit"

      bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

      include /etc/sway/config.d/*
    '';
  };
}
