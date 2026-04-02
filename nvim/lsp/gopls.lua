return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.mod', '.git' },
  settings = {
    gopls = {
      gofumpt = false,
      completeFunctionCalls = false,
    },
  },
}
