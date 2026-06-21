-- ~/.config/nvim/lua/options.lua
-- Sensible editor defaults. Loaded from init.lua before plugins.

local opt = vim.opt

-- UI
opt.number = true             -- show absolute line number on current line
opt.relativenumber = true     -- and relative numbers on others (jump with [N]j/k)
opt.signcolumn = "yes"        -- always reserve sign column to avoid text shift
opt.cursorline = true         -- highlight current line
opt.termguicolors = true      -- 24-bit colors (needed for onedark)
opt.scrolloff = 8             -- keep 8 lines of context around cursor
opt.sidescrolloff = 8
opt.wrap = true               -- soft-wrap long lines at the window edge
opt.linebreak = true          -- break at word boundaries, not mid-word
opt.breakindent = true        -- wrapped lines continue at the same indent level
opt.showmode = false          -- lualine already shows mode

-- Indentation: 2-space default, ftplugin overrides for languages that want 4
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true          -- case-sensitive if pattern has uppercase
opt.hlsearch = true
opt.incsearch = true

-- Splits open in the natural direction
opt.splitright = true
opt.splitbelow = true

-- Persistence: undo history survives across restarts
opt.undofile = true

-- System clipboard (Wayland/X11 via wl-clipboard; install wl-clipboard on Linux)
opt.clipboard = "unnamedplus"

-- Mouse support in all modes (handy for SyncTeX inverse search clicks)
opt.mouse = "a"

-- Faster CursorHold / nvim-tree responsiveness
opt.updatetime = 250

-- Don't pass messages to ins-completion-menu
opt.shortmess:append("c")

-- Git: add all → commit → push in one step
vim.keymap.set("n", "<leader>ga", function()
  vim.ui.input({ prompt = "Commit message: " }, function(msg)
    if not msg or msg == "" then return end
    local out = vim.fn.system(
      string.format("git add -A && git commit -m %s && git push 2>&1", vim.fn.shellescape(msg))
    )
    vim.notify(out, vim.v.shell_error == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
  end)
end, { desc = "Git: add all, commit, push" })

-- Git: pull in the current repo
vim.keymap.set("n", "<leader>gl", function()
  local result = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " pull 2>&1")
  vim.notify(result, vim.v.shell_error == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
end, { desc = "Git: pull" })

-- Custom navigation keybindings
vim.keymap.set("n", "<M-l>", "w", { noremap = true, desc = "Next word" })
vim.keymap.set("n", "<M-h>", "b", { noremap = true, desc = "Previous word" })
vim.keymap.set("n", "<M-k>", "<C-u>", { noremap = true, desc = "Half page up" })
vim.keymap.set("n", "<M-j>", "<C-d>", { noremap = true, desc = "Half page down" })
vim.keymap.set("n", "<C-k>", "<C-b>", { noremap = true, desc = "Page up" })
vim.keymap.set("n", "<C-j>", "<C-f>", { noremap = true, desc = "Page down" })

-- Left-click × in the winbar to close the focused split
_G.WinbarClose = function()
  if vim.fn.winnr("$") > 1 then
    vim.cmd("close")
  end
end
vim.o.winbar = "%=%@v:lua.WinbarClose@  ×  %X"
