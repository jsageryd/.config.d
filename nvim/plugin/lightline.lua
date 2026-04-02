vim.g.lightline = {
  colorscheme = 'wombat',
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'modified' },
    },
    right = {
      { 'lineinfo' },
      { 'percent' },
      { 'fileformat', 'fileencoding', 'filetype' },
    },
  },
  inactive = {
    left = {
      { 'filename', 'modified' },
    },
    right = {
      { 'lineinfo' },
      { 'percent' },
    },
  },
}
