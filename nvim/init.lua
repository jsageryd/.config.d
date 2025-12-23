-- Automatically remove upon save: trailing whitespace, blank lines at beginning
-- of file, blank lines at end of file. Skip diffs to avoid corrupting patches.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[
    if &modifiable && &filetype !=# 'diff' |
      :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e |
    endif
  ]],
})

-- Use <CR> for :noh
vim.keymap.set('n', '<CR>', ':noh<CR><CR>', { silent = true })

-- Use <S-tab> to cycle backwards over windows
vim.keymap.set('n', '<S-tab>', '<c-w>W')

-- Toggle folds with space, but only if there is a fold
vim.keymap.set("n", "<Space>", function()
  if vim.fn.foldlevel(".") > 0 then
    return "za"
  else
    return "<Space>"
  end
end, { expr = true, silent = true })

-- Use <tab> to cycle over windows
vim.keymap.set('n', '<tab>', '<c-w>w')

-- Create new folds with space in visual mode
vim.keymap.set('v', '<Space>', 'zf')

-- Date shortcut
vim.cmd('iab <expr> _d strftime("%Y-%m-%d")')
--
-- Avoid vim swap files and backups
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Set leader to ,
vim.g.mapleader = ','

-- Indicate the 50th, 72nd, and 80th column
vim.opt.colorcolumn = '50,72,80'

-- Expand tabs to spaces
vim.opt.expandtab = true

-- Use block cursor for all modes
vim.opt.guicursor = 'n-v-c-sm:block'

-- Make lowercase searches case-insensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Turn off incremental search
vim.opt.incsearch = false

-- Prevent lines from wrapping in the middle of words
vim.opt.linebreak = true

-- Turn off modelines CVE-2007-2438
vim.opt.modelines = 0

-- Enable increment/decrement (^a/^x) of letters
vim.opt.nf:append('alpha')

-- Show line numbers
vim.opt.nu = true

-- Number of spaces inserted or removed with >> or <<
vim.opt.shiftwidth = 2

-- Set spell checker language
vim.opt.spelllang = 'en_gb'

-- Size of a tab
vim.opt.tabstop = 2

-- Wrap at 80 characters by default
vim.opt.textwidth = 80

-- Prevent line wrapping
vim.opt.wrap = false

-- Prevent search from wrapping at EOF
vim.opt.wrapscan = false

-- Set better text for folded lines
function _G.better_fold_text()
  local text = vim.trim(vim.fn.getline(vim.v.foldstart))

  if text:match('^[%(%[{<]$') then
    local secondline = vim.trim(vim.fn.getline(vim.v.foldstart + 1))
    secondline = secondline:gsub('%s+', ' ')
    text = text .. ' ' .. secondline
  end

  local lastline = vim.trim(vim.fn.getline(vim.v.foldend))

  if lastline:match('^[%)%]}<>]') then
    text = text .. ' ' .. lastline
  end

  local indent_level = vim.fn.indent(vim.v.foldstart)
  local indent

  if indent_level == 0 then
    indent = string.rep('-', indent_level)
  else
    indent = string.rep('-', indent_level - 1) .. ' '
  end

  return indent .. text .. ' (' .. vim.v.foldend - vim.v.foldstart + 1 .. ')'
end

vim.opt.foldtext = 'v:lua.better_fold_text()'

require('gen').setup({
  model = "qwen3-coder:30b", -- The default model to use.
  quit_map = "q", -- set keymap to close the response window
  retry_map = "<c-r>", -- set keymap to re-send the current prompt
  accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
  host = "localhost", -- The host running the Ollama service.
  port = "11434", -- The port on which the Ollama service is listening.
  display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split" or "vertical-split".
  show_prompt = false, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
  show_model = true, -- Displays which model you are using at the beginning of your chat session.
  no_auto_close = false, -- Never closes the window automatically.
  file = false, -- Write the payload to a temporary file to keep the command short.
  hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
  init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
  -- Function to initialize Ollama
  command = function(options)
    local body = {model = options.model, stream = true}
    return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
  end,
  -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
  -- This can also be a command string.
  -- The executed command must return a JSON object with { response, context }
  -- (context property is optional).
  -- list_models = '<omitted lua function>', -- Retrieves a list of model names
  result_filetype = "markdown", -- Configure filetype of the result buffer
  debug = false -- Prints errors and the command which is run.
})
