require('rose-pine').setup({
-- 	variant = 'dawn',
--	dark_variant = 'moon',
   	bold_vert_split = false,
  	dim_nc_background = true,
    disable_background = true,
    disable_float_background = true,
  	disable_italics = false,
    highlight_groups = {
      Comment = { italic = true }
    }
})

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')
