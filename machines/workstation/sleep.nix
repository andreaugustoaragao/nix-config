{
  services.logind.extraConfig = ''
    IdleAction=sleep
    IdleActionSec=30min
  '';
}
