vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- exit insert mode with kk or jj
vim.keymap.set('i', 'kk', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- map ; to :
vim.keymap.set('n', ';', ':', { noremap = true })

-- map <leader>fm to :Format
vim.keymap.set('n', '<leader>fm', ':Format<CR>', { noremap = true })

-- keymap for tab
vim.keymap.set('n', '<leader>x', ':tabclose<CR>', { desc = 'Tab Close' })
vim.keymap.set('n', 'tn', ':tabnext<CR>', { desc = '[T]ab [N]ext' })
vim.keymap.set('n', 'tp', ':tabprevious<CR>', { desc = '[T]ab [P]revious' })
