return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      config = {
        header = vim.split('Neovim ' .. tostring(vim.version()) .. "\n", '\n'),
      },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
