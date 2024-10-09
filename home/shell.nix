{
  pkgs,
  config,
  ...
}: {
  home.shellAliases = {
    v = "nvim";
    k = "kubectl";
    dcu = "docker compose up";
    dcub = "docker compose up --build .";
  };

  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      extraOptions = ["--group-directories-first"];
      icons = true;
      git = false;
    };
  };

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
