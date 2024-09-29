local api = vim.api
api.nvim_command("autocmd TermOpen * startinsert")
api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber")
api.nvim_command("autocmd TermEnter * setlocal signcolumn=no")

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.opt.titlestring = 'My Terminal'
        vim.opt.title = true
    end
})
