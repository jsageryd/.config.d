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
      { 'fileformat', 'fileencoding', 'filetype', 'lsp' },
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
]])
