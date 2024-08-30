{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = [pkgs.protonmail-bridge];

  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "Protonmail Bridge";
      After = ["network.target"];
    };

    Service = {
      Restart = "always";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --noninteractive";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  accounts.email = {
    accounts.posteo = {
      address = "andre-a-o-aragao@proton.me";
      imap.host = "127.0.0.1:1143";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Andre Aragao";
      signature = {
        text = ''
        '';
        showSignature = "append";
      };
      passwordCommand = "mail-password";
      smtp = {
        host = "127.0.0.1:1125";
      };
      userName = "andre-a-o-aragao@proton.me";
    };
  };
}
