{
  services.logind.extraConfig = ''
    HandlePowerKey=sleep
    IdleAction=hybrid-sleep
    IdleActionSec=5min
  '';
}
