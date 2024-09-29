
-- heavily inspired by https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
-- Define the highlight groups using Vimscript
vim.cmd [[
  highlight StatusLineFilename guifg=#e0def4 guibg=NONE
  highlight StatusLinePosition guifg=#d3869b guibg=NONE gui=bold
  highlight StatusLineModified guifg=#fe8019 guibg=NONE
  highlight StatusLineMode guifg=#9ccfd8 guibg=NONE
  highlight StatusLineFiletype guifg=#ebbcba guibg=NONE gui=bold
]]

local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format("%s ", modes[current_mode]):upper()
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = "%#StatusLine#"
  if current_mode == "n" then
    mode_color = "%#StatusLine#"
  elseif current_mode == "i" or current_mode == "ic" then
    mode_color = "%#ModesInsert#"
  elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
    mode_color = "%#Visual#"
  elseif current_mode == "R" then
    mode_color = "%#StatuslineReplaceAccent#"
  elseif current_mode == "c" then
    mode_color = "%#StatuslineCmdLineAccent#"
  elseif current_mode == "t" then
    mode_color = "%#StatuslineTerminalAccent#"
  end
  return mode_color
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fpath == "" or fpath == "." then
    return " "
  end

  return string.format(" %%<%s/", fpath)
end

local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then
    return ""
  end
  return fname .. " "
end

local function is_lsp_attached()
  local clients = vim.lsp.buf_get_clients(0)  -- 0 for the current buffer
  if next(clients) ~= nil then
    return true
  else
    return false
  end
end

local function lsp()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  if is_lsp_attached () then
    for k, level in pairs(levels) do
      count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    errors = " %#DiagnosticSignError# " .. count["errors"]
    warnings = " %#DiagnosticSignWarn# " .. count["warnings"]
    hints = " %#DiagnosticSignHint# " .. count["hints"]
    info = " %#DiagnosticSignInfo# " .. count["info"]

    return "%#StatusLineModified#" .. errors .. warnings .. hints .. info .. "%#Normal#"
  end
  return ""
end



local function get_file_icon()
  local bufname = vim.fn.bufname('%')
  local extension = vim.fn.expand('%:e')
  local icon = require'nvim-web-devicons'.get_icon(bufname, extension)
  if icon == nil then
    -- Set a default icon or return an empty string if no icon is found
    icon = '' -- This is a default icon, you can choose any other
  end
  return icon
end


local function filetype()
  return get_file_icon() .. string.format(" %s ", vim.bo.filetype):upper()
end

-- Then you can incorporate this function into your status line setup
vim.o.statusline = "%#MyFileIconHighlight# " .. get_file_icon() .. " %f"
-- ... the rest of your statusline setup ...

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

Statusline = {}

Statusline.active = function()
  return table.concat {
    "%#StatuslineMode#",
    -- update_mode_colors(),
    mode(),
    --"%#Normal# ",
    "%#StatusLineFilename#",
    filepath(),
    filename(),
    lsp(),
    "%=%#StatusLineFileType#",
    filetype(),
    "%#StatusLinePosition#",
    lineinfo(),
  }
end

function Statusline.inactive()
  return " %F"
end

local function is_current_filename_fish()
  local filename_with_path = vim.api.nvim_buf_get_name(0)
  local f = vim.fn.fnamemodify(filename_with_path, ':t')  -- Get filename
  local filename_without_extension = vim.fn.fnamemodify(f, ':r')  -- Remove extension
  -- Check if the filename without extension is 'fish'
  return filename_without_extension == 'fish'
end

function Statusline.terminal()
  local f = filename()
  if is_current_filename_fish() then
    return table.concat {"%#StatusLineTerm# 󰈺 ", f }
  else
    return table.concat {"%#StatusLineTerm#  ", f }
  end
end


vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au TermOpen term://*  setlocal statusline=%!v:lua.Statusline.terminal()
  augroup END
]], false)


