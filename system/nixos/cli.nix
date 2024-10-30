{pkgs, ...}: {
  programs.fish = {
    enable = true;
  };

  programs.nix-index.enableFishIntegration = true;

  #services.envfs.enable = true;

  programs.starship = {
    enable = true;
    presets = ["nerd-font-symbols"];
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
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    configure = {
      customRC = ''
          lua << EOF
        ${builtins.readFile ../neovim/persistence.lua}
        ${builtins.readFile ../neovim/lsp.lua}
        ${builtins.readFile ../neovim/completion.lua}
        ${builtins.readFile ../neovim/animate.lua}
        ${builtins.readFile ../neovim/treesitter.lua}
        ${builtins.readFile ../neovim/theme.lua}
        ${builtins.readFile ../neovim/starter.lua}
        ${builtins.readFile ../neovim/illuminate.lua}
        ${builtins.readFile ../neovim/trouble.lua}
        ${builtins.readFile ../neovim/lualine.lua}
        ${builtins.readFile ../neovim/notify.lua}
        ${builtins.readFile ../neovim/noice.lua}
        ${builtins.readFile ../neovim/telescope.lua}
        ${builtins.readFile ../neovim/indentblankline.lua}
        ${builtins.readFile ../neovim/navic.lua}
        ${builtins.readFile ../neovim/symbolsoutline.lua}
        ${builtins.readFile ../neovim/dap.lua}
        ${builtins.readFile ../neovim/conform.lua}
        ${builtins.readFile ../neovim/none-ls.lua}
        ${builtins.readFile ../neovim/oil.lua}
        ${builtins.readFile ../neovim/init.lua}
        ${builtins.readFile ../neovim/setup/mappings.lua}
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [lazy-nvim pkgs.luajitPackages.luarocks];
      };
    };
  };

  programs.fish = {
    interactiveShellInit = ''
      zoxide init fish | source
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      fish_vi_key_bindings
      function fish_greeting
          #fastfetch_with_logo

         fastfetch --logo-height 10 -s os:kernel:wm:terminal:cpu:gpu:memory:disk:localip:dns:battery:uptime
         fortune|lolcat
      end

      function is_alacritty
          # Check if TERM_PROGRAM is set to "Alacritty"
          if test "$TERM_PROGRAM" = "Alacritty"
              return 0
          # Alternatively, check if ALACRITTY_LOG is set
          else if set -q ALACRITTY_LOG
              return 0
          else
              return 1
          end
      end

      function fastfetch_with_logo
         if is_alacritty || set -q SSH_CONNECTION || is_st
              fastfetch --logo-height 10 -s os:kernel:wm:terminal:cpu:gpu:memory:disk:localip:dns:battery:uptime
          else
              fastfetch --sixel ${./nixos-frosty.png} --logo-height 13 --logo-preserve-aspect-ratio -s os:kernel:wm:terminal:cpu:gpu:memory:disk:localip:dns:battery:uptime
          end
      end

      function cd --description 'Change directory smartly with tmux sessions'
           if set -q TMUX && [ (count $argv) -eq 0 ]
               set -l tmux_root_dir (tmux show-environment TMUX_SESSION_ROOT_DIR 2>/dev/null | sed -n 's/^TMUX_SESSION_ROOT_DIR=//p')
               if test -n "$tmux_root_dir" -a -d "$tmux_root_dir"
                   z $tmux_root_dir
                   # echo "Changed to TMUX session root directory: $tmux_root_dir"
               else
                   # echo "TMUX_SESSION_ROOT_DIR is not set or is not a valid directory."
                   z
               end
           else
               # If arguments are provided or not in a tmux session, use regular cd
               z $argv
               # echo "Changed to directory: $argv"
           end
       end

      function y
       set tmp (mktemp -t "yazi-cwd.XXXXXX")
       yazi $argv --cwd-file="$tmp"
       if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
       end
       rm -f -- "$tmp"
      end
    '';

    shellAliases = {
      ls = "eza --icons";
      ll = "eza --icons --group-directories-first -al";
      v = "nvim";
      fz = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
      cd = "z";
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.resurrect
      tmuxPlugins.tmux-fzf
      tmuxPlugins.continuum
    ];
    extraConfig = builtins.readFile ../tmux/tmux.conf;
  };

  environment.systemPackages = with pkgs; [
    (
      let
        scriptContent = builtins.readFile ../tmux/tmux-sessionizer;
      in
        writeShellScriptBin "tmux-sessionizer" scriptContent
    )
    (
      let
        scriptContent = builtins.readFile ../tmux/tmux-window-icons;
      in
        writeShellScriptBin "tmux-window-icons" scriptContent
    )
    (
      let
        scriptContent = builtins.readFile ../tmux/tmux-right-status;
      in
        writeShellScriptBin "tmux-right-status" scriptContent
    )
    (
      let
        scriptContent = builtins.readFile ../tmux/tmux-git-status;
      in
        writeShellScriptBin "tmux-git-status" scriptContent
    )

    inetutils
    unzip
    zip
    unrar
    p7zip
    pciutils
    usbutils
    tree
    fzf
    fortune
    lolcat
    cowsay
    dwt1-shell-color-scripts
    curl
    wget
    killall
    htop
    btop
    bottom
    gdu
    entr
    nixd
    fd
    lua-language-server
    nodePackages_latest.bash-language-server
    marksman
    p11-kit
    nix-prefetch-github
    onefetch
    bc
    cmatrix
    ripgrep
    entr
    openssl
    speedtest-cli
    git
    busybox
    dig.dnsutils
    bat
    alejandra
    nixfmt-classic
    zoxide
    ticker
  ];

  programs.mtr.enable = true;
  environment.localBinInPath = true;
  environment.binsh = "${pkgs.dash}/bin/dash"; #faster, consumes less memory
}
