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
      { 'fileformat', 'fileencoding', 'filetype', 'lsp', 'copilot' },
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
  component_function = {
    lsp = 'LightlineLsp',
    copilot = 'LightlineCopilot',
  },
}

function _G.LightlineLsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = {}
  for _, c in ipairs(clients) do
    if c.name ~= 'GitHub Copilot' then
      names[#names + 1] = c.name
    end
  end
  return table.concat(names, ', ')
end

vim.cmd([[
  function! LightlineLsp() abort
    return v:lua.LightlineLsp()
  endfunction

  function! LightlineCopilot() abort
    if exists('*copilot#Enabled')
      return copilot#Enabled() ? 'copilot' : 'c̶o̶p̶i̶l̶o̶t̶'
    endif
    return ''
  endfunction
]])

-- Refresh lightline after :Copilot enable/disable
local copilot_state = nil
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local enabled = vim.g.copilot_enabled
    if enabled ~= copilot_state then
      copilot_state = enabled
      vim.fn['lightline#update']()
    end
  end,
})
