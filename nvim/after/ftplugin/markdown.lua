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

-- In-progress task items: bold + tint so active work stands out.
vim.api.nvim_set_hl(0, 'MarkdownTaskInProgress', { bold = true, fg = '#c8e6c8', bg = '#5a8a5a' })

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

-- Decoration provider for callouts and task-item styling. Runs during the
-- redraw pipeline (per visible window, on the visible row range) and places
-- ephemeral extmarks for one frame at a time. No persistent state, so there's
-- nothing to debounce, invalidate, or get out of sync with treesitter.

local ns = vim.api.nvim_create_namespace('markdown_callout')

local tag_q = vim.treesitter.query.parse('markdown_inline',
  '((shortcut_link (link_text) @tag))')
local bq_q = vim.treesitter.query.parse('markdown', '(block_quote) @bq')
local task_q = vim.treesitter.query.parse('markdown',
  [[
    (list_item
      (task_list_marker_checked)
      (paragraph (inline) @text))
  ]])
-- `[/]` is not a real task_list_marker in the grammar, so match any list_item
-- with a paragraph and check the paragraph text for the literal `[/] ` prefix.
local inprog_q = vim.treesitter.query.parse('markdown',
  '(list_item (paragraph (inline) @p))')

-- Per-window cache populated in on_win, consumed in on_line. Keyed by winid
-- and invalidated each redraw cycle.
--
-- Shape: cache[winid] = { [row] = { {col, end_col, hl_group, hl_eol?}, ... } }
local cache = {}

local function add(decos, row, col, end_col, hl, hl_eol)
  local list = decos[row]
  if not list then list = {}; decos[row] = list end
  list[#list + 1] = { col, end_col, hl, hl_eol }
end

local function build(bufnr, top, bot)
  local decos = {}

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'markdown')
  if not ok then return decos end

  -- No parser:parse() call: Neovim ensures the tree is current for the
  -- visible range before decoration providers run.

  -- 1. Find callout tag lines from inline trees (visible range only).
  local tag_at = {}
  parser:for_each_tree(function(tree, lt)
    if lt:lang() ~= 'markdown_inline' then return end
    for _, node in tag_q:iter_captures(tree:root(), bufnr, top, bot) do
      local text = vim.treesitter.get_node_text(node, bufnr)
      if TAGS[text] then tag_at[(node:range())] = TAGS[text][1] end
    end
  end)

  parser:for_each_tree(function(tree, lt)
    if lt:lang() ~= 'markdown' then return end

    -- 2. Callout block_quotes: paint each line of a tagged block_quote.
    -- Iterate slightly past the visible range so a callout that starts
    -- above the viewport still paints its visible body lines.
    for _, node in bq_q:iter_captures(tree:root(), bufnr, 0, bot) do
      local sr, _, er = node:range()
      local hl = tag_at[sr]
      if hl and er > top then
        for line = math.max(sr, top), math.min(er - 1, bot - 1) do
          add(decos, line, 0, -1,
            line == sr and (hl .. '.head') or hl, true)
        end
      end
    end

    -- Paint a task body across one or more lines.
    local function paint_body(sr, sc, er, ec, hl)
      if er < top or sr >= bot then return end
      local lines = vim.api.nvim_buf_get_lines(bufnr, sr, er + 1, false)
      for i, line in ipairs(lines) do
        local row = sr + i - 1
        if row >= top and row < bot then
          local start_col = (i == 1) and sc or (line:match('^%s*'):len())
          local end_col = (row == er) and ec or #line
          if end_col > start_col then
            add(decos, row, start_col, end_col, hl, false)
          end
        end
      end
    end

    -- 3. Completed task items: dim + strikethrough body text.
    for id, node in task_q:iter_captures(tree:root(), bufnr, 0, bot) do
      if task_q.captures[id] == 'text' then
        local sr, sc, er, ec = node:range()
        paint_body(sr, sc, er, ec, 'MarkdownTaskDone')
      end
    end

    -- 4. In-progress task items: render `[/]` like `[ ]` + bold the body.
    for _, node in inprog_q:iter_captures(tree:root(), bufnr, 0, bot) do
      local sr, sc, er, ec = node:range()
      if er >= top and sr < bot then
        local line = vim.api.nvim_buf_get_lines(bufnr, sr, sr + 1, false)[1]
          or ''
        if line:sub(sc + 1, sc + 4) == '[/] ' then
          add(decos, sr, sc, sc + 3, '@markup.list.unchecked', false)
          paint_body(sr, sc + 4, er, ec, 'MarkdownTaskInProgress')
        end
      end
    end
  end)

  return decos
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, winid, bufnr, toprow, botrow)
    if vim.bo[bufnr].filetype ~= 'markdown' then
      cache[winid] = nil
      return false
    end
    -- botrow is inclusive in this API; use exclusive bound for our queries.
    cache[winid] = build(bufnr, toprow, botrow + 1)
  end,
  on_line = function(_, winid, bufnr, row)
    local decos = cache[winid]
    if not decos then return end
    local list = decos[row]
    if not list then return end
    for _, d in ipairs(list) do
      vim.api.nvim_buf_set_extmark(bufnr, ns, row, d[1], {
        end_row = d[4] and row + 1 or row,
        end_col = d[4] and 0 or d[2],
        hl_group = d[3],
        hl_eol = d[4] or false,
        ephemeral = true,
        priority = 110,
      })
    end
  end,
})

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
