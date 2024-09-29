vim.g.codelens_enabled = true

require("ibl").setup({
	enabled = true,
	indent = {
		char = "│",
		tab_char = "│",
	},
	scope = {
		enabled = false,
	},
	exclude = {
		filetypes = {
			"help",
			"alpha",
			"dashboard",
			"neo-tree",
			"Trouble",
			"trouble",
			"lazy",
			"mason",
			"notify",
			"toggleterm",
			"lazyterm",
		},
	},
})

require("colorizer").setup({
	user_default_options = {
		AARRGGBB = true,
	},
})

require("illuminate").configure({
	delay = 200,
	large_file_cutoff = 2000,
	large_file_overrides = {
		providers = { "lsp", "treesitter", "regex" },
	},
})
