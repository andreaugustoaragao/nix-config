{pkgs, ...}: {
  programs.fish = {
    enable = true;
  };

  programs.nix-index.enableFishIntegration = true;

  #services.envfs.enable = true;
  environment.localBinInPath = true;

  programs.starship = {
    enable = true;
    presets = ["nerd-font-symbols"];
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
    entr
    nixd
    fd
    lua-language-server
    nodePackages_latest.bash-language-server
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
    toybox
  ];

  programs.mtr.enable = true;

  environment.binsh = "${pkgs.dash}/bin/dash"; #faster, consumes less memory
}
