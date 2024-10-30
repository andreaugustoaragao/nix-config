{
  services.logind.extraConfig = ''
    HandlePowerKey=sleep
    IdleAction=sleep
    IdleActionSec=5min
  '';
}
