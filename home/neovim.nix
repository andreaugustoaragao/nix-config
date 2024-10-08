# THIS IS HERE BECAUSE DARWIN NIX DOES NOT HAVE programs.neovim LIKE NIXOS 
{
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


}
