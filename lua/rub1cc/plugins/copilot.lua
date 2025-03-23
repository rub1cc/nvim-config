return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    vim.g.copilot_node_command = '~/.nvm/versions/node/v20.10.0/bin/node'
  end,
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
    { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  },
  build = 'make tiktoken', -- Only on MacOS or Linux
  opts = {
    -- See Configuration section for options
  },
  -- See Commands section for default commands if you want to lazy load on them
}
