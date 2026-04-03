-- Show spelling suggestions in a completion-style popup
vim.keymap.set('n', 'z=', function()
  local word = vim.fn.expand('<cword>')
  local suggestions = vim.fn.spellsuggest(word, 20)
  if #suggestions == 0 then
    vim.notify('No suggestions for "' .. word .. '"', vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, s in ipairs(suggestions) do
    table.insert(items, { word = s })
  end

  -- When completion finishes, undo if nothing was explicitly accepted
  vim.api.nvim_create_autocmd('CompleteDone', {
    once = true,
    callback = function()
      vim.schedule(function()
        local completed = vim.v.completed_item
        if not completed or not completed.word or completed.word == '' then
          vim.cmd('normal! u')
        end
        vim.cmd('stopinsert')
      end)
    end,
  })

  -- Use feedkeys so ciw + complete() both run in insert mode context
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('ciw', true, false, true),
    'n',
    false
  )
  vim.schedule(function()
    vim.fn.complete(vim.fn.col('.'), items)

    -- Map Escape to dismiss without accepting (C-e cancels completion, then undo + leave insert)
    vim.keymap.set('i', '<Esc>', function()
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<C-e>', true, false, true),
        'n',
        false
      )
      vim.schedule(function()
        vim.cmd('stopinsert')
        vim.cmd('normal! u')
      end)
    end, { buffer = 0 })

    -- Clean up the Escape mapping once completion is done
    vim.api.nvim_create_autocmd('CompleteDone', {
      once = true,
      callback = function()
        pcall(vim.keymap.del, 'i', '<Esc>', { buffer = 0 })
      end,
    })
  end)
end)
