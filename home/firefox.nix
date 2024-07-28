{
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (pkgs) runCommandNoCC writeText;
  inherit (pkgs.lib.strings) concatStrings;
  inherit (pkgs.lib.attrsets) mapAttrsToList;

  firefox-ui-fix = pkgs.callPackage ./firefox-ui-fix.nix {};

  settings = writeText "user.js" (concatStrings (mapAttrsToList (name: value: ''
      user_pref("${name}", ${builtins.toJSON value});
    '')
    config.programs.firefox.profiles.aragao.settings));

  settings-file = runCommandNoCC "firefox-settings" {} ''
    cat '${firefox-ui-fix}/user.js' '${settings}' > $out
  '';
in {
  # heavily inspired by
  # https://github.com/TLATER/dotfiles/blob/7ce77190696375aab3543f7365d298729a548df5/home-modules/firefox-webapp.nix

  xdg.configFile."tridactyl/tridactylrc".text = ''
  '';

  home.file.".mozilla/firefox/aragao/chrome/icons" = {
    source = "${firefox-ui-fix}/icons";
  };

  home.file.".mozilla/firefox/${config.programs.firefox.profiles.aragao.path}/user.js" = {
    source = settings-file;
  };

  programs.firefox = {
    enable = false;
    package = pkgs.firefox.override {
      cfg = {
        #enableTridactylNative = true;
        #enableBukubrow = true;
      };
    };

    policies = {DefaultDownloadDirectory = "\${home}/downloads";};

    profiles."aragao" = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        clearurls
        decentraleyes
        libredirect
        no-pdf-download
        tridactyl
        ublock-origin
        onepassword-password-manager
        darkreader
      ];

      #userChrome = builtins.readFile "${firefox-ui-fix}/css/leptonChrome.css";
      #userContent = builtins.readFile "${firefox-ui-fix}/css/leptonContent.css";
      settings = {
        # Performance settings
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;

        # Re-bind ctrl to super (would interfere with tridactyl otherwise)
        "ui.key.accelKey" = 91;

        # Keep the reader button enabled at all times; really don't
        # care if it doesn't work 20% of the time, most websites are
        # crap and unreadable without this
        "reader.parse-on-load.force-enabled" = true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Actual settings
        "app.shield.optoutstudies.enabled" = false;
        "app.update.auto" = false;
        #"browser.bookmarks.restore_default_bookmarks" = false;
        "browser.contentblocking.category" = "strict";
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.discovery.enabled" = false;
        "browser.laterrun.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = false;
        "browser.protections_panel.infoMessage.seen" = true;
        "browser.quitShortcut.disabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.ssb.enabled" = true;
        #"browser.toolbars.bookmarks.visibility" = "never";
        #"browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.suggest.openpage" = false;
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        #"dom.security.https_only_mode" = true;
        #"dom.security.https_only_mode_ever_enabled" = true;
        #"extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
    };
  };

  #  programs.firefox.webapps.teams-firefox = {
  #    url = "https://teams.microsoft.com";
  #    id = 2;
  #    name = "Teams - Firefox";
  #    icon = "teams";
  #    extraSettings = config.programs.firefox.profiles."aragao".settings;
  #    categories = [ "Network" "InstantMessaging" ];
  #  };
  #
  #  programs.firefox.webapps.teams-outlook = {
  #    url = "https://outlook.office.com";
  #    id = 3;
  #    name = "Outlook - Firefox";
  #    icon = "ms-outlook";
  #    extraSettings = config.programs.firefox.profiles."aragao".settings;
  #    categories = [ "X-Internet" ];
  #  };
}
