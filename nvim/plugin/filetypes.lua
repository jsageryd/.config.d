vim.filetype.add({
  extension = {
    ndjson = 'ndjson',
  },
})

-- Use tree-sitter's JSON parser for ndjson
vim.treesitter.language.register('json', 'ndjson')
