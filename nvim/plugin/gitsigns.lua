require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Use <Leader>{<Down>,<Up>} to go to next and previous unstaged change
    vim.keymap.set('n', '<Leader><Down>', function() gs.nav_hunk('next') end, { buffer = bufnr })
    vim.keymap.set('n', '<Leader><Up>', function() gs.nav_hunk('prev') end, { buffer = bufnr })
  end,
})
