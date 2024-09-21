return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_node_command = '~/.nvm/versions/node/v20.10.0/bin/node'
  end,
}
