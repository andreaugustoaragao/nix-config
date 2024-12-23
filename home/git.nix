{
  pkgs,
  config,
  ...
}: let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in {
  programs.git = {
    #package = pkgs.gitFull;
    enable = true;
    aliases = {
      c = "commit";
      co = "checkout";
      s = "status";
      p = "push";
    };
    # signing = {
    #  signByDefault = if isLinux then true else false;
    #  key = "0xDDD13A55026CFA51";
    #};
    #    extraConfig = {
    #      credential.helper = "${
    #        pkgs.git.override {withLibsecret = true;}
    #      }/bin/git-credential-libsecret";
    #    };

    includes = [
      {
        condition = "gitdir/i=${config.home.homeDirectory}/projects/personal/**";
        contents = {
          user = {
            name = "andreaugustoaragao";
            email = "andrearag@gmail.com";
          };
        };
      }
      {
        condition = "gitdir/i=${config.home.homeDirectory}/projects/work/**";
        contents = {
          user = {
            name = "aragao";
            email = "aragao@avaya.com";
          };
        };
      }
    ];

    #TODO review https://pickard.cc/posts/git-identity-home-manager/
  };
}
