return {
  'sindrets/diffview.nvim', -- optional - Diff integration
  event = "VeryLazy",
  config = function()
    require('diffview').setup {
      use_icons = false, -- Requires nvim-web-devicons
      view = {
        merge_tool = {
          layout = 'diff1_plain',
        },
      },
      file_panel = {
        listing_style = 'list', -- "list" | "tree",
      },
    }
  end,
}
