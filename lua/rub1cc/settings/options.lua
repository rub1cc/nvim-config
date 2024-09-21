vim.g.mapleader = ' ' -- set <space> as leader key
vim.g.maplocalleader = ' ' -- set <space> as local leader key

vim.g.title = true -- set title of the window to the value of the titlestring option

vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers

vim.opt.mouse = 'a' -- enable mouse mode
vim.opt.showmode = false -- don't show mode in command line, since it's already shown in status line
vim.opt.clipboard = 'unnamedplus' -- sync system clipboard with vim clipboard

vim.opt.breakindent = true -- enable break indent

vim.opt.undofile = true -- enable undofile

vim.opt.ignorecase = false -- enable case-sensitive search
vim.opt.smartcase = true -- enable case-sensitive search

vim.opt.signcolumn = 'yes' -- keep single column on by default

vim.opt.updatetime = 250 -- decrease update time

vim.opt.timeoutlen = 300 -- decrease mapped sequence timeout

vim.opt.splitbelow = true -- configurre how new split windows are opened
vim.opt.splitright = true -- configurre how new split windows are opened

vim.opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how neovim will display certain whitespace characters in the editor.

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

vim.opt.cursorline = true -- Show which line your cursor is on

vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

vim.opt.hlsearch = true -- Set highlight on search, but clear on pressing <Esc> in normal mode
