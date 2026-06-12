vim.filetype.add({
  extension = {
    ndjson = 'ndjson',
  },
})

-- Use tree-sitter's JSON parser for ndjson
vim.treesitter.language.register('json', 'ndjson')

-- Use tree-sitter's HCL parser for Terraform
vim.treesitter.language.register('hcl', 'terraform')
vim.treesitter.language.register('hcl', 'terraform-vars')
