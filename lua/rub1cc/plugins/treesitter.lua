return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'json',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
      'css',
      'scss',
      'yaml',
      'toml',
      'python',
    },
    autopairs = { enable = true },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
