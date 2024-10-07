{
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    IdleAction=hibernate
    IdleActionSec=30min
  '';
}
