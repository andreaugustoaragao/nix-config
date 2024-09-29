require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = function (_,bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
  },
  incremental_selection = { enable = true},
  indent = { enable = true },
  autotag = { enable = true },
  endwise = { enable = true },
}
