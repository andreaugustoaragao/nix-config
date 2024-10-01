{
  config,
  pkgs,
  lib,
  ...
}: {
  # create ~/.config/systemd/user/default.target.wants/redshift.service to enable
  services.redshift = {
    enable = false;
    settings.redshift = {
      brightness-day = "1";
      brightness-night = "0.8";
      adjustment-method = "randr";
    };

    temperature = {
      day = 5500;
      night = 3000;
    };
    longitude = "-104.9896447";
    latitude = "40.0179675";
    #provider = "geoclue2";
    tray = false;
  };
}
