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

  #  programs.mbsync.enable = true;
  #  programs.mbsync.extraConfig = ''
  #  '';
  #  programs.msmtp.enable = true;
  #  programs.notmuch = {
  #    enable = true;
  #    hooks = {
  #      preNew = "mbsync --all";
  #    };
  #  };
  #  programs.neomutt = {
  #    enable = true;
  #  };
  #  #  accounts.email = {
  #    #openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
  #    #certificatesFile = "${config.home.homeDirectory}/.config/protonmail/cert.pem";
  #    accounts.proton = {
  #      enable = false;
  #      address = "andre-a-o-aragao@proton.me";
  #      imap.host = "127.0.0.1";
  #      imap.port = 1143;
  #      imap.tls.enable = true;
  #      imap.tls.useStartTls = true;
  #      #imap.tls.certificatesFile = "${config.home.homeDirectory}/.config/protonmail/cert.pem";
  #
  #      neomutt.enable = true;
  #      mbsync = {
  #        enable = true;
  #        create = "maildir";
  #      };
  #      msmtp.enable = true;
  #      notmuch.enable = true;
  #      primary = true;
  #      realName = "Andre Aragao";
  #      signature = {
  #        text = ''
  #        '';
  #        showSignature = "append";
  #      };
  #      #passwordCommand = "~/.config/protonmail/get-bridge-pwd.sh";
  #      smtp = {
  #        host = "127.0.0.1";
  #        port = 1025;
  #      };
  #      userName = "andre-a-o-aragao@proton.me";
  #    };
  #  };
}
