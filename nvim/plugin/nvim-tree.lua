require('nvim-tree').setup({
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del('n', '<tab>', { buffer = bufnr })
  end,
  filters = {
    custom = { '.DS_Store' },
  },
  git = {
    enable = false,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
  renderer = {
    indent_width = 1,
    indent_markers = {
      enable = false,
    },
    icons = {
      padding = ' ',
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = false,
        modified = false,
        diagnostics = false,
      },
      glyphs = {
        folder = {
          arrow_closed = '▶',
          arrow_open = '▼',
        },
      },
    },
  },
  view = {
    width = {
      min = 10,
      max = 30,
      padding = 1,
    },
    float = {
      enable = true,
    },
  },
})

-- Toggle nvim-tree with <Leader>n
vim.keymap.set('n', '<Leader>n', ':NvimTreeToggle<CR>', { silent = true })

-- Mute nvim-tree folder arrows and file icons
vim.api.nvim_set_hl(0, 'NvimTreeFolderIcon', { fg = '#4a4e54' })
vim.api.nvim_set_hl(0, 'NvimTreeFileIcon', { fg = '#707880' })
