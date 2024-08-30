{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.gpg.enable = true;
  programs.gpg.homedir = "${config.xdg.dataHome}/gnupg";
  programs.gpg.mutableKeys = true;
  programs.gpg.mutableTrust = true;

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableExtraSocket = true;
    defaultCacheTtl = 60 * 60 * 8; # in seconds
    defaultCacheTtlSsh = 60 * 60 * 8;
    enableSshSupport = true;
    enableScDaemon = false; #no smart card
    pinentryPackage = pkgs.pinentry-curses;
    sshKeys = [
      "7E94299ADBECE24CBF21A28F5A6877BAE2EADC11"
    ];
  };
}
