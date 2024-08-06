{
  config,
  pkgs,
  lib,
  ...
}: let
 # chatGptIcon = pkgs.fetchurl {
 #   url = "https://cdn.oaistatic.com/_next/static/media/apple-touch-icon.59f2e898.png";
 #   sha256 = "024yhp9kqky0v9yviz9z60gwfqksvbx7vf8gads03idvvcja89hn";
 # };

  msTeamsIcon = pkgs.fetchurl {
    url = "https://cdn.icon-icons.com/icons2/2397/PNG/512/microsoft_office_teams_logo_icon_145726.png";
    sha256 = "0b9nmxm03r90a3fdfyzrwk4f7plv74699w5ir369nd24m0zx5ry3";
  };

  msOutlookIcon = pkgs.fetchurl {
    url = "https://cdn.icon-icons.com/icons2/2397/PNG/512/microsoft_office_outlook_logo_icon_145721.png";
    sha256 = "0lwd3x2c3jgzi7pkynrahijbi5a2l60l49k98g9jvcvp8a5pk27a";
  };

  rocketChatIcon = pkgs.fetchurl {
    url = "https://cdn.icon-icons.com/icons2/2621/PNG/512/brand_rocket_chat_icon_157334.png";
    sha256 = "1rc3b8fgp6a4dpmndhp2b8fczhp7mmmxh624y58hr43xxzr7y1yb";
  };

  redditIcon = pkgs.fetchurl {
    url = "https://cdn.icon-icons.com/icons2/1195/PNG/512/1490889653-reddit_82537.png";
    sha256 = "01ja74q5i797s0cfhr8byqq1bzzix23hswimij663ylm864w7lna";
  };

 # twitterIcon = pkgs.fetchurl {
 #   url = "https://cdn.icon-icons.com/icons2/836/PNG/512/Twitter_icon-icons.com_66803.png";
 #   sha256 = "1mlqxxj2rwwv439lvdv4k4djhmwk92lv1riywk94r9hcmk5bbs92";
 # };

  vimCheatSheetIcon = pkgs.fetchurl {
    url = "https://cdn.icon-icons.com/icons2/1381/PNG/512/vim_94609.png";
    sha256 = "0fnrcrsrrnchrgjbg0hszynj2g2m674b3nc4ky8pdb3zgc1490sc";
  };

  youtubeMusicIcon = pkgs.fetchurl {
    url = "https://cdn.icon-icons.com/icons2/3132/PNG/512/youtube_music_social_network_song_multimedia_icon_192250.png";
    sha256 = "0hxwh8x4xmpa9rpmscds9sip08a6xz9s58xncd2mlnyzh8pa447b";
  };
in {
  home.packages = with pkgs; [
    xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
    xdg-user-dirs
  ];

  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    # manage $XDG_CONFIG_HOME/mimeapps.list
    # xdg search all desktop entries from $XDG_DATA_DIRS, check it by command:
    #  echo $XDG_DATA_DIRS
    # the system-level desktop entries can be list by command:
    #   ls -l /run/current-system/sw/share/applications/
    # the user-level desktop entries can be list by command(user ryan):
    #  ls /etc/profiles/per-user/ryan/share/applications/
    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["chromium.desktop"];
        lf = ["lf.desktop"];
        nvim = ["nvim.desktop"];
      in {
        "application/json" = nvim;
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

        "text/html" = browser;
        "text/xml" = nvim;
        "text/plain" = nvim;
        "text/markdown" = nvim;
        "text/x-go" = nvim;
        "text/x-java" = nvim;
        "text/x-python" = nvim;
        "application/x-shellscript" = nvim;
        "application/yaml" = nvim;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;

        "x-scheme-handler/about" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/unknown" = nvim;
        "inode/directory" = "thunar.desktop";
        "image/*" = browser;
      };

      associations.removed = {
        # ......
      };
    };

    userDirs = {
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/projects";
      enable = false;
      createDirectories = false;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs}/screenshots";
      };
    };
  };

  xdg.desktopEntries = {
    tmux-default = {
      name = "Tmux Default Session";
      genericName = "Tmux default session";
      exec = "alacritty --class Alacritty,default-tmux -e tmux new-session -s default -A";
      icon = "utilities-terminal";
    };

    teams = {
      name = "Teams";
      genericName = "Microsoft Teams";
      exec = "chromium -app=https://teams.microsoft.com";
      #icon = msTeamsIcon;
      icon = "teams";
    };

    outlook = {
      name = "Outlook";
      genericName = "Microsoft Outlook";
      exec = "chromium -app=https://outlook.office.com";
      #icon = msOutlookIcon;
      icon = "ms-outlook";
    };

    music = {
      name = "Youtube Music";
      genericName = "Youtube Music";
      exec = "chromium -app=https://music.youtube.com";
      icon = youtubeMusicIcon;
    };

    vimCheatSheet = {
      name = "Vim Cheat Sheet";
      genericName = "Vim Cheat Sheet";
      exec = "chromium -app=https://vim.rtorr.com";
      icon = vimCheatSheetIcon;
    };

    reddit = {
      name = "Reddit";
      genericName = "Reddit";
      exec = "chromium -app=https://reddit.com";
      icon = redditIcon;
    };

    twitter = {
      name = "Twitter";
      genericName = "Twitter";
      exec = "chromium -app=https://x.com";
  #    icon = twitterIcon;
    };

    chatgpt = {
      name = "ChatGPT";
      genericName = "ChatGPT";
      exec = "chromium -app=https://chat.openai.com";
   #   icon = chatGptIcon;
    };

    rocketchat = {
      name = "Rocket Chat";
      genericName = "Rocket Chat";
      exec = "chromium -app=https://avaya.rocket.chat";
      icon = rocketChatIcon;
    };
  };

  home.activation = with config.xdg; {
    createXdgCacheAndDataDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG \
        ${config.home.homeDirectory}/screenshots

      $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG \
        ${config.home.homeDirectory}/projects

      $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG \
        ${config.home.homeDirectory}/projects/personal

      $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG \
        ${config.home.homeDirectory}/projects/work

      $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG \
        ${config.home.homeDirectory}/screenshots

    '';

    #TODO remove this from here - should be in the java.nix file
    createJavaCertificates = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f $HOME/.config/java-cacerts ]; then
        $DRY_RUN_CMD ${pkgs.p11-kit.bin}/bin/trust extract --format=java-cacerts --purpose=server-auth $HOME/.config/java-cacerts
      fi
    '';
  };
}
