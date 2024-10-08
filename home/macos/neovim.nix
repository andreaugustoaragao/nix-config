# THIS IS HERE BECAUSE DARWIN NIX DOESjjjjjjjjjjNOT HAVE programs.neovim LIKE NIXOS 
{
  pkgs,
  ...
}:
{

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


}
