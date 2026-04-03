-- Turn on tree-sitter
vim.treesitter.start()

-- Fold based on tree-sitter
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Don't auto-fold
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99

-- Use 2-space soft tabs when cursor is inside injected SQL
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
  buffer = 0,
  callback = function()
    local parser = vim.treesitter.get_parser(0)
    if not parser then return end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lang_tree = parser:language_for_range({row - 1, col, row - 1, col})
    if lang_tree and lang_tree:lang() == "sql" then
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    else
      vim.opt_local.expandtab = false
      vim.opt_local.shiftwidth = 0
      vim.opt_local.softtabstop = 0
    end
  end
})

-- Organize imports and format on save
-- https://go.dev/gopls/editor/vim#neovim
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
