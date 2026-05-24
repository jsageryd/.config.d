-- Size of space inserted or removed with >> or <<
vim.opt_local.shiftwidth = 2

-- Size of a tab
vim.opt_local.tabstop = 2

-- Set text width
vim.opt_local.textwidth = 80

-- GitHub-style callouts: color the entire `> [!TAG] ... > body` block.
-- `[!TAG]` itself is highlighted via after/queries/markdown_inline/highlights.scm.
-- Whole-block coloring is done here with extmarks because the block_quote
-- node (markdown parser) doesn't know whether it's a callout — that lives
-- in the markdown_inline parser.

-- Mono palette: grayscale headings, muted color only on callouts so they
-- stand out without shouting.
local TAGS = {
  ['!NOTE']      = { '@markup.callout.note',      '#8eb3ca' }, -- blue
  ['!TIP']       = { '@markup.callout.tip',       '#9dc18c' }, -- sage green
  ['!IMPORTANT'] = { '@markup.callout.important', '#bea4c6' }, -- mauve
  ['!WARNING']   = { '@markup.callout.warning',   '#dca270' }, -- amber
  ['!CAUTION']   = { '@markup.callout.caution',   '#cf7d7d' }, -- brick red
}
for _, v in pairs(TAGS) do
  vim.api.nvim_set_hl(0, v[1], { fg = v[2] })              -- body
  vim.api.nvim_set_hl(0, v[1] .. '.head', { fg = v[2], bold = true }) -- header
end

-- Headings: pure grayscale gradient, bold.
local HEADINGS = {
  ['@markup.heading.1'] = '#d0d0d0',
  ['@markup.heading.2'] = '#b8b8b8',
  ['@markup.heading.3'] = '#9e9e9e',
  ['@markup.heading.4'] = '#888888',
  ['@markup.heading.5'] = '#707070',
  ['@markup.heading.6'] = '#5a5a5a',
}
for group, fg in pairs(HEADINGS) do
  vim.api.nvim_set_hl(0, group, { fg = fg, bold = true })
end

-- Inline emphasis: render strikethrough as actual strikethrough.
vim.api.nvim_set_hl(0, '@markup.strikethrough', { strikethrough = true })

-- Inline code: bright green text on a dim green chip background.
vim.api.nvim_set_hl(0, '@markup.raw.markdown_inline', {
  fg = '#7ee787', -- bright green
  bg = '#1a2e1f', -- dim green, same hue
})

-- Fenced code blocks (```): full-width darker block via extmarks (the
-- @markup.raw.block capture only covers the text, not trailing whitespace
-- or empty lines, so we paint each line of the fenced_code_block node).
-- Fenced code blocks (```): tinted fg for blocks without a recognized
-- injected language (where treesitter can't supply syntax colors).
vim.api.nvim_set_hl(0, '@markup.raw.block', { fg = '#81be88' })

-- Completed task items: dim + strikethrough.
vim.api.nvim_set_hl(0, 'MarkdownTaskDone', {
  fg = '#999999',
  strikethrough = true,
})

-- In-progress task items: bold so active work stands out.
vim.api.nvim_set_hl(0, 'MarkdownTaskInProgress', { bold = true })

-- Dim the checked-checkbox marker to match the strikethrough text color.
vim.api.nvim_set_hl(0, '@markup.list.checked', { fg = '#666666' })

-- Plain blockquotes: brighter steel so the > matches the body text.
vim.api.nvim_set_hl(0, '@markup.quote', { fg = '#9eb2c2' })
-- Backticks themselves: render like plain surrounding text (override the
-- chip background coming from @markup.raw).
local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
vim.api.nvim_set_hl(0, '@markup.raw.delimiter', {
  fg = normal.fg,
  bg = normal.bg,
})

local ns = vim.api.nvim_create_namespace('markdown_callout')
local tag_q = vim.treesitter.query.parse('markdown_inline',
  '((shortcut_link (link_text) @tag))')
local bq_q = vim.treesitter.query.parse('markdown', '(block_quote) @bq')
local task_q = vim.treesitter.query.parse('markdown',
  [[
    (list_item
      (task_list_marker_checked) @_marker
      (paragraph) @text)
  ]])
-- `[/]` is not a real task_list_marker in the grammar, so match any list_item
-- with a paragraph and check the paragraph text for the literal `[/] ` prefix.
local inprog_q = vim.treesitter.query.parse('markdown',
  '(list_item (paragraph) @p)')

local function refresh(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local ok, parser = pcall(vim.treesitter.get_parser, buf, 'markdown')
  if not ok then return end
  parser:parse(true)

  -- Find callout tag lines from inline trees.
  local tag_at = {}
  parser:for_each_tree(function(tree, lt)
    if lt:lang() ~= 'markdown_inline' then return end
    for _, node in tag_q:iter_captures(tree:root(), buf) do
      local text = vim.treesitter.get_node_text(node, buf)
      if TAGS[text] then tag_at[(node:range())] = TAGS[text][1] end
    end
  end)

  -- Paint each block_quote whose start line is tagged.
  parser:for_each_tree(function(tree, lt)
    if lt:lang() ~= 'markdown' then return end
    for _, node in bq_q:iter_captures(tree:root(), buf) do
      local sr, _, er = node:range()
      local hl = tag_at[sr]
      if hl then
        for line = sr, er - 1 do
          vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {
            end_row = line + 1, end_col = 0,
            hl_group = line == sr and (hl .. '.head') or hl,
            hl_eol = false, priority = 105,
          })
        end
      end
    end
    -- Completed task items: dim + strikethrough only the text after the marker.
    for id, node in task_q:iter_captures(tree:root(), buf) do
      if task_q.captures[id] == 'text' then
        local sr, sc, er, ec = node:range()
        vim.api.nvim_buf_set_extmark(buf, ns, sr, sc, {
          end_row = er, end_col = ec,
          hl_group = 'MarkdownTaskDone',
          priority = 110,
        })
      end
    end
    -- In-progress task items: paint `[/]` like `[ ]` so it doesn't read as
    -- plain blue punctuation, and bold the text after it.
    for _, node in inprog_q:iter_captures(tree:root(), buf) do
      local sr, sc, er, ec = node:range()
      local line = vim.api.nvim_buf_get_lines(buf, sr, sr + 1, false)[1] or ''
      if line:sub(sc + 1, sc + 4) == '[/] ' then
        vim.api.nvim_buf_set_extmark(buf, ns, sr, sc, {
          end_col = sc + 3, hl_group = '@markup.list.unchecked', priority = 110,
        })
        vim.api.nvim_buf_set_extmark(buf, ns, sr, sc + 4, {
          end_row = er, end_col = ec, hl_group = 'MarkdownTaskInProgress', priority = 110,
        })
      end
    end
  end)
end

-- Toggle markdown task checkboxes: cycle [ ] -> [/] -> [x] -> [ ] with <Space>.
-- Multi-line ranges (visual / :1,5ToggleTask) snap every line to the next state
-- of the first line, so a mixed block converges, then advances in lockstep.
-- Single lines cycle from their own state.
local CYCLE = { [' '] = '/', ['/'] = 'x', ['x'] = ' ' }

local function toggle_task(line1, line2, sync)
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
  local forced
  if sync then
    local first = lines[1] and lines[1]:match('%[([^%]])%]')
    forced = CYCLE[first] or '/'
  end
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('%[([^%]])%]', function(cur)
      return '[' .. (forced or CYCLE[cur] or '/') .. ']'
    end, 1)
  end
  vim.api.nvim_buf_set_lines(0, line1 - 1, line2, false, lines)
end

vim.api.nvim_buf_create_user_command(0, 'ToggleTask',
  function(o) toggle_task(o.line1, o.line2, o.range == 2) end, { range = true })

vim.keymap.set('n', '<Space>', ':ToggleTask<CR>',
  { buffer = 0, silent = true, desc = 'Toggle markdown task checkbox' })

-- In visual mode, toggle then restore the selection so <Space> can be pressed
-- repeatedly to keep cycling the same range. `:` leaves visual mode and
-- clobbers `'<`/`'>` order, so we read the marks ourselves and re-enter
-- linewise visual over the same lines.
vim.keymap.set('x', '<Space>', function()
  vim.cmd('normal! \27') -- <Esc>, so '<, '> reflect the selection just made
  local s = vim.fn.line("'<")
  local e = vim.fn.line("'>")
  if s > e then s, e = e, s end
  toggle_task(s, e, true)
  vim.cmd(string.format('normal! %dGV%dG', s, e))
end, { buffer = 0, silent = true, desc = 'Toggle markdown task checkbox' })

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI' }, {
  group = vim.api.nvim_create_augroup('markdown_callout', { clear = false }),
  buffer = 0,
  callback = function(a) refresh(a.buf) end,
})
refresh(0)
