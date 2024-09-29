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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
      };
    };
  };
}
