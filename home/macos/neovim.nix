{pkgs, ...}: let
  qutebrowserWideVine = pkgs.qutebrowser.overrideAttrs {
    enableWideVine = true;
    enableVulkan = true;
  };
in {
  imports = [
    ../go.nix
    ../git.nix
    ../vscode.nix
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 1200;
      scan_timeout = 10;
      format = ''
        [](bold cyan) $directory$cmd_duration$all$kubernetes$azure$docker_context$time
        $character'';
      directory = {home_symbol = " ";};
      golang = {
        #style = "bg:#79d4fd fg:#000000";
        style = "fg:#79d4fd";
        format = "[$symbol($version)]($style)";
        symbol = " ";
      };
      git_status = {
        disabled = true;
      };
      git_branch = {
        disabled = true;
        symbol = " ";
        #style = "bg:#f34c28 fg:#413932";
        style = "fg:#f34c28";
        format = "[  $symbol$branch(:$remote_branch)]($style)";
      };
      azure = {
        disabled = true;
        #style = "fg:#ffffff bg:#0078d4";
        style = "fg:#0078d4";
        format = "[  ($subscription)]($style)";
      };
      java = {
        format = "[ ($version)]($style)";
      };
      kubernetes = {
        #style = "bg:#303030 fg:#ffffff";
        style = "fg:#2e6ce6";
        #format = "\\[[󱃾 :($cluster)]($style)\\]";
        format = "[ 󱃾 ($cluster)]($style)";
        disabled = true;
      };
      docker_context = {
        disabled = false;
        #style = "fg:#1d63ed";
        format = "[ 󰡨 ($context) ]($style)";
      };
      gcloud = {disabled = true;};
      hostname = {
        ssh_only = true;
        format = "<[$hostname]($style)";
        trim_at = "-";
        style = "bold dimmed fg:white";
        disabled = true;
      };
      line_break = {disabled = true;};
      username = {
        style_user = "bold dimmed fg:blue";
        show_always = false;
        format = "user: [$user]($style)";
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraConfig = ''
      lua << EOF
      ${builtins.readFile ../../system/neovim/persistence.lua}
      ${builtins.readFile ../../system/neovim/lsp.lua}
      ${builtins.readFile ../../system/neovim/completion.lua}
      ${builtins.readFile ../../system/neovim/animate.lua}
      ${builtins.readFile ../../system/neovim/treesitter.lua}
      ${builtins.readFile ../../system/neovim/theme.lua}
      ${builtins.readFile ../../system/neovim/starter.lua}
      ${builtins.readFile ../../system/neovim/illuminate.lua}
      ${builtins.readFile ../../system/neovim/trouble.lua}
      ${builtins.readFile ../../system/neovim/lualine.lua}
      ${builtins.readFile ../../system/neovim/notify.lua}
      ${builtins.readFile ../../system/neovim/noice.lua}
      ${builtins.readFile ../../system/neovim/telescope.lua}
      ${builtins.readFile ../../system/neovim/indentblankline.lua}
      ${builtins.readFile ../../system/neovim/navic.lua}
      ${builtins.readFile ../../system/neovim/symbolsoutline.lua}
      ${builtins.readFile ../../system/neovim/dap.lua}
      ${builtins.readFile ../../system/neovim/conform.lua}
      ${builtins.readFile ../../system/neovim/none-ls.lua}
      ${builtins.readFile ../../system/neovim/oil.lua}
      ${builtins.readFile ../../system/neovim/init.lua}
      ${builtins.readFile ../../system/neovim/setup/mappings.lua}
    '';
  };

  home.packages = with pkgs; [
    poppler_utils #pdftotext
    ueberzugpp #image visualization
    yazi #yazi file manager
    exiftool
    chafa
    imagemagick
    ffmpegthumbnailer
    neovide
    flameshot
    #qutebrowserWideVine
  ];

  xdg.configFile."yazi/yazi.toml" = {source = ../yazi.toml;};
  xdg.configFile."yazi/theme.toml" = {source = ../catppuccin-mocha.yazi;};
  home.file.".qutebrowser/config.py" = {
    source = ../qutebrowser/config.py;
    executable = false;
  };
  xdg.configFile."aerospace/aerospace.toml" = {source = ./aerospace.toml;};
}
