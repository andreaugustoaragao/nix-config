{
  pkgs,
  config,
  ...
}: {
  home.shellAliases = {
    v = "nvim";
    fz = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
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

    fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
        function fish_greeting
          fortune|lolcat
        end

            function cd --description 'Change directory smartly with tmux sessions'
                if set -q TMUX && [ (count $argv) -eq 0 ]
                    set -l tmux_root_dir (tmux show-environment TMUX_SESSION_ROOT_DIR 2>/dev/null | sed -n 's/^TMUX_SESSION_ROOT_DIR=//p')
                    if test -n "$tmux_root_dir" -a -d "$tmux_root_dir"
                        builtin cd $tmux_root_dir
                        # echo "Changed to TMUX session root directory: $tmux_root_dir"
                    else
                        # echo "TMUX_SESSION_ROOT_DIR is not set or is not a valid directory."
                        builtin cd
                    end
                else
                    # If arguments are provided or not in a tmux session, use regular cd
                    builtin cd $argv
                    # echo "Changed to directory: $argv"
                end
            end
      '';
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
    starship = {
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
  };
  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/share/go/bin"
  ];

  home.packages = with pkgs; [
    lolcat
    fortune
    entr
    neofetch
    nixfmt-classic
    bottom
    gdu
    p7zip
    tree
    dwt1-shell-color-scripts
    htop
    # lua-language-server
    poppler_utils
  ];
}
