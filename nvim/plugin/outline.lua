-- Symbol outline sidebar: a "map" of the current file's functions, types,
-- methods, etc. Sourced from tree-sitter, so it is instant and needs no LSP.
-- Per-language extractors walk the syntax tree into { name, kind, range }
-- records. States: (no parser) if tree-sitter can't parse the buffer,
-- (no extractor) if there's no extractor, (no symbols) if empty.
--
-- Toggle with <Leader>o. Inside: <CR> or double-click jumps to symbol.

local ts = vim.treesitter

-- Helpers shared by the per-language extractors.
local function node_text(n, buf)
  return n and ts.get_node_text(n, buf) or ''
end

-- Append a record. range is a node whose extent is used for jump + current
-- symbol; sel (optional) narrows the jump target to e.g. the name node.
local function emit(out, kind, name, range, sel, depth)
  if not (name and name ~= '' and range) then return end
  local sr, sc, er, ec = range:range()
  local jr, jc = sr, sc
  if sel then jr, jc = sel:range() end
  out[#out + 1] = { kind = kind, name = name, depth = depth or 0,
    srow = sr, scol = sc, erow = er, ecol = ec, jrow = jr, jcol = jc }
end

-- Per-filetype extractors: given root node + buffer, return a flat, ordered
-- list of symbol records. Keep these small and grammar-specific.
local extractors = {}

extractors.go = function(root, buf, out)
  -- Receiver type name from a method's receiver node, ignoring the receiver
  -- variable, pointer star, and generic type params: (b *genericBox[T]) -> genericBox.
  local function receiver(recv)
    if not recv then return nil, false end
    local ptr = false
    for pd in recv:iter_children() do
      if pd:type() == 'parameter_declaration' then
        local ty = pd:field('type')[1]
        if ty and ty:type() == 'pointer_type' then
          ptr = true
          ty = ty:named_child(0)
        end
        -- Unwrap generic_type (genericBox[T]) down to its type_identifier.
        while ty and ty:type() == 'generic_type' do ty = ty:field('type')[1] end
        return ty and node_text(ty, buf) or nil, ptr
      end
    end
    return nil, ptr
  end

  -- Emit struct fields / interface methods nested under a type at depth 1.
  local function type_members(ty, depth)
    local tt = ty and ty:type()
    if tt == 'struct_type' then
      for list in ty:iter_children() do
        if list:type() == 'field_declaration_list' then
          for fld in list:iter_children() do
            if fld:type() == 'field_declaration' then
              local fty = fld:field('type')[1]
              local names = {}
              for fn in fld:iter_children() do
                if fn:type() == 'field_identifier' then names[#names + 1] = fn end
              end
              if #names == 0 then
                -- Embedded field: its name is the (possibly qualified/pointer)
                -- type, e.g. stressType, io.Reader, *Base.
                if fty then emit(out, 'field', node_text(fty, buf), fld, fty, depth) end
              else
                for _, fn in ipairs(names) do
                  emit(out, 'field', node_text(fn, buf), fld, fn, depth)
                  -- Nested anonymous struct: recurse its fields one level deeper.
                  if fty and fty:type() == 'struct_type' then
                    type_members(fty, depth + 1)
                  end
                end
              end
            end
          end
        end
      end
    elseif tt == 'interface_type' then
      for elem in ty:iter_children() do
        if elem:type() == 'method_elem' then
          for mn in elem:iter_children() do
            if mn:type() == 'field_identifier' then
              emit(out, 'imeth', node_text(mn, buf), elem, mn, depth)
              break
            end
          end
        elseif elem:type() == 'type_elem' then
          -- Either an embedded interface (io.Reader) or a type constraint
          -- (~int | ~int64). A lone type name is an embed; anything with a
          -- union / ~ approximation is a constraint (type set).
          local child = elem:named_child(0)
          local ct = child and child:type()
          local single = elem:named_child_count() == 1
            and (ct == 'type_identifier' or ct == 'qualified_type')
          local text = node_text(elem, buf):gsub('%s+', ' ')
          emit(out, single and 'interface' or 'constraint', text, elem, elem, depth)
        end
      end
    end
  end

  -- Subtests: t.Run("name", func(t *testing.T) { ... }) inside a test function.
  -- Any x.Run(<string>, ...) call counts -- that covers t/b/f receivers and
  -- renamed variables alike. Nested t.Run calls nest in the outline, so a table
  -- test's cases appear under their parent. Only the call's function literal is
  -- descended into, so a nested Run in a helper closure still lands sensibly.
  local function subtests(node, depth)
    if not node then return end
    for child in node:iter_children() do
      local handled = false
      if child:type() == 'call_expression' then
        local fn = child:field('function')[1]
        local sel = fn and fn:type() == 'selector_expression' and fn:field('field')[1]
        if sel and node_text(sel, buf) == 'Run' then
          local args = child:field('arguments')[1]
          local first = args and args:named_child(0)
          local ft = first and first:type()
          if ft == 'interpreted_string_literal' or ft == 'raw_string_literal' then
            -- Strip the surrounding quotes/backticks; keep the literal text as
            -- written (Go rewrites spaces to underscores only in -run names).
            local name = node_text(first, buf):gsub('^["`]', ''):gsub('["`]$', '')
            emit(out, 'subtest', name, child, first, depth)
            -- Recurse into the closure argument only, one level deeper.
            for i = 1, (args:named_child_count() or 1) - 1 do
              local a = args:named_child(i)
              if a and a:type() == 'func_literal' then subtests(a:field('body')[1], depth + 1) end
            end
            handled = true
          end
        end
      end
      if not handled then subtests(child, depth) end
    end
  end

  -- A type_spec (type X struct/interface/...) or type_alias (type X = Y).
  local function type_spec(spec, decl)
    local name = spec:field('name')[1]
    if spec:type() == 'type_alias' then
      emit(out, 'type', node_text(name, buf), decl, name)
      return
    end
    local ty = spec:field('type')[1]
    local tt = ty and ty:type()
    local kind = tt == 'struct_type' and 'struct'
      or tt == 'interface_type' and 'interface' or 'type'
    emit(out, kind, node_text(name, buf), decl, name)
    type_members(ty, 1)
  end

  -- A var_spec/const_spec; may declare multiple names (var a, b int). The
  -- const_spec 'name' field also includes comma tokens, so filter to identifiers.
  local function value_spec(spec, kind)
    for _, name in ipairs(spec:field('name')) do
      if name:type() == 'identifier' then
        emit(out, kind, node_text(name, buf), spec, name)
      end
    end
  end

  for node in root:iter_children() do
    local t = node:type()
    if t == 'function_declaration' then
      emit(out, 'func', node_text(node:field('name')[1], buf), node, node:field('name')[1])
      subtests(node:field('body')[1], 1)
    elseif t == 'method_declaration' then
      local rtype, ptr = receiver(node:field('receiver')[1])
      local mname = node_text(node:field('name')[1], buf)
      local name = rtype and ('(' .. (ptr and '*' or '') .. rtype .. ').' .. mname) or mname
      emit(out, ptr and 'meth' or 'vmeth', name, node, node:field('name')[1])
      subtests(node:field('body')[1], 1)
    elseif t == 'type_declaration' then
      -- Children are type_spec / type_alias (grouped type ( ... ) lists both).
      for spec in node:iter_children() do
        local st = spec:type()
        if st == 'type_spec' or st == 'type_alias' then
          type_spec(spec, node)
        end
      end
    elseif t == 'var_declaration' or t == 'const_declaration' then
      local kind = t == 'var_declaration' and 'var' or 'const'
      -- Specs may be direct children or nested in a *_spec_list (grouped ( ... )).
      for child in node:iter_children() do
        local ct = child:type()
        if ct:match('_spec$') then
          value_spec(child, kind)
        elseif ct:match('_spec_list$') then
          for spec in child:iter_children() do
            if spec:type():match('_spec$') then value_spec(spec, kind) end
          end
        end
      end
    end
  end
end

-- JSON: walk pairs, kind derived from the value node; recurse into objects
-- and arrays so nested keys nest in the outline.
extractors.json = function(root, buf, out)
  local KIND_OF = {
    object = 'object', array = 'array', string = 'string',
    number = 'number', ['true'] = 'bool', ['false'] = 'bool', null = 'null',
  }
  local function walk(node, depth)
    for child in node:iter_children() do
      if child:type() == 'pair' then
        local key = child:field('key')[1]
        local val = child:field('value')[1]
        local kind = KIND_OF[val and val:type()] or 'other'
        emit(out, kind, node_text(key, buf):gsub('^"(.*)"$', '%1'), child, key, depth)
        if val and (val:type() == 'object' or val:type() == 'array') then
          walk(val, depth + 1)
        end
      elseif child:type() == 'object' or child:type() == 'array' then
        walk(child, depth)
      end
    end
  end
  -- Emit each top-level value (object/array) as a root heading the outline,
  -- then walk its contents one level deeper. Handles NDJSON / multiple JSON
  -- documents, where `document` has several top-level value children. Scalars
  -- at the top level are emitted as leaves; anything else falls back to walking.
  local roots = 0
  for child in root:iter_children() do
    local ct = child:type()
    if ct == 'object' or ct == 'array' then
      emit(out, KIND_OF[ct], ct, child, child, 0)
      walk(child, 1)
      roots = roots + 1
    elseif KIND_OF[ct] then
      emit(out, KIND_OF[ct], ct, child, child, 0)
      roots = roots + 1
    end
  end
  if roots == 0 then walk(root, 0) end
end
extractors.jsonc = extractors.json

-- Markdown: the heading hierarchy. The grammar nests `section` nodes by
-- heading level, each starting with an atx_heading (# .. ######) or a
-- setext_heading. Depth follows the section nesting.
extractors.markdown = function(root, buf, out)
  local function heading_text(h)
    -- The heading text is an `inline` node: a direct child for ATX headings,
    -- nested under a `paragraph` for setext headings.
    for c in h:iter_children() do
      if c:type() == 'inline' then return vim.trim(node_text(c, buf)) end
      if c:type() == 'paragraph' then
        for gc in c:iter_children() do
          if gc:type() == 'inline' then return vim.trim(node_text(gc, buf)) end
        end
      end
    end
    return vim.trim(node_text(h, buf):gsub('^#+%s*', ''):gsub('%s*#*$', ''))
  end
  local function level(h)
    for c in h:iter_children() do
      local m = c:type():match('^atx_h(%d)_marker$')
      if m then return tonumber(m) end
      if c:type():match('^setext_h(%d)_underline$') then
        return tonumber(c:type():match('%d'))
      end
    end
    return 1
  end
  -- Each `section` node holds its own heading (as its first heading child) plus
  -- its body and any nested `section`s. Emit the heading using the *section* as
  -- the range so the current-symbol match (which picks the innermost containing
  -- range) lights up while the cursor is anywhere in the section body, not only
  -- on the heading line. The heading node stays the jump/selection target. We
  -- only recurse into nested sections, so each heading is emitted exactly once.
  local function walk(node, depth)
    for child in node:iter_children() do
      if child:type() == 'section' then
        local heading
        for gc in child:iter_children() do
          local gt = gc:type()
          if gt == 'atx_heading' or gt == 'setext_heading' then heading = gc break end
        end
        if heading then
          emit(out, 'h' .. level(heading), heading_text(heading), child, heading, depth)
        end
        walk(child, depth + 1)
      end
    end
  end
  walk(root, 0)
end

-- Kind label overrides (a value-receiver method reuses the meth label but a
-- distinct kind key so it can be coloured separately).
-- Font-safe Unicode glyphs per kind (no Nerd Font needed). Colour disambiguates
-- further. All are single-cell BMP characters present in standard monospace
-- fonts. Chosen for semantic fit and mutual visual distinctness.
local KIND_LABEL = {
  func = 'ƒ', meth = '•', vmeth = '•', imeth = '○',   -- ƒ function, • method, ○ interface method
  struct = '■', type = 't', interface = '◇',
  field = '▪', const = 'c', var = 'v', constraint = 'c',
  subtest = '▸',                                      -- ▸ t.Run subtest
  -- JSON: literal structural marks read most clearly
  object = '{', array = '[', string = '"', number = '#', bool = '⊤', null = '∅',
  -- Markdown headings: a filled square; per-level colour sets the tone
  h1 = '◼', h2 = '◼', h3 = '◼', h4 = '◼', h5 = '◼', h6 = '◼',
  other = '?',
}

-- Filetypes where blank separators are unhelpful (JSON keys nest constantly,
-- which would blank-separate nearly every line).
local NO_SEPARATORS = { json = true, jsonc = true }

-- Flatten records into display lines / parallel state arrays. A blank line is
-- inserted before a root (depth 0) symbol when it has nested members, follows a
-- nested block, or changes kind from the previous root -- so blocks stand apart
-- and flat runs of the same kind stay grouped.
local function build(records, out, separators)
  local prev_label
  for i, r in ipairs(records) do
    local label = KIND_LABEL[r.kind] or r.kind
    local nested = r.depth == 0 and records[i + 1] and records[i + 1].depth > 0
    local after_block = r.depth == 0 and records[i - 1] and records[i - 1].depth > 0
    local kind_change = r.depth == 0 and prev_label and label ~= prev_label
    if separators and (nested or after_block or kind_change) and #out.text > 0 then
      local n = #out.text + 1
      out.text[n], out.kinds[n], out.lines[n], out.ranges[n] = '', '', false, false
    end
    if r.depth == 0 then prev_label = label end
    local n = #out.text + 1
    out.text[n] = ('  '):rep(r.depth) .. label .. ' ' .. r.name
    out.kinds[n] = r.kind
    out.lines[n] = { r.jrow, r.jcol }
    out.ranges[n] = { r.srow, r.scol, r.erow, r.ecol }
  end
end


local MIN_WIDTH, MAX_WIDTH = 10, 60  -- min like nvim-tree; max wide enough for long constraints

local ns = vim.api.nvim_create_namespace('outline_kind')

local state = {
  win = nil, buf = nil, src_win = nil,
  src_buf = nil,  -- source buffer last rendered
  tick = nil,     -- its changedtick at last render
  lines = {},   -- outline line -> { lnum, col } jump target
  ranges = {},  -- outline line -> { s_line, s_char, e_line, e_char }
  cur = nil,    -- outline line currently marked as the cursor's symbol
}

-- Resize to fit the widest line (+1 pad), clamped, like nvim-tree.
local function fit_width()
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then return end
  local content = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)) do
    content = math.max(content, vim.fn.strdisplaywidth(line))
  end
  vim.api.nvim_win_set_width(state.win, math.max(MIN_WIDTH, math.min(content + 1, MAX_WIDTH)))
end

-- Move the outline cursor to the symbol under the source cursor, so the
-- window's cursorline doubles as the current-symbol marker. Cheap: one O(n)
-- pass over the small range list with a fast early-out when unchanged. When no
-- symbol matches, the cursor is left where it is (like nvim-tree).
local function highlight_current()
  if not (state.win and vim.api.nvim_win_is_valid(state.win)
      and state.src_win and vim.api.nvim_win_is_valid(state.src_win)) then return end

  local pos = vim.api.nvim_win_get_cursor(state.src_win)
  local line, col = pos[1] - 1, pos[2]

  -- Innermost symbol whose line range contains the cursor. Matching is
  -- line-based (not column-gated) so leading indentation doesn't exclude a
  -- match. Among equal-span candidates we then use columns to disambiguate
  -- several symbols sharing a source line (e.g. compact `{"a":1,"b":2}`, a key
  -- and its inline value, or Go's `var a, b int` where the names share one
  -- range): prefer the one whose jump position is at or before the cursor
  -- column and closest to it, falling back to the earliest when none precede.
  -- Jump position (the name node) is used rather than the range start so
  -- sibling names sharing a range are still told apart.
  local best, best_span, best_dist
  for i, r in ipairs(state.ranges) do
    if r and line >= r[1] and line <= r[3] then
      local span = r[3] - r[1]
      local jump = state.lines[i]
      -- Distance from the symbol's jump column to the cursor on the start line;
      -- negative (starts after the cursor) is deprioritised via a big offset.
      local dist = (jump and jump[1] == line) and (col - jump[2]) or 0
      if dist < 0 then dist = dist + 1e9 end
      if not best_span or span < best_span
          or (span == best_span and dist < best_dist) then
        best, best_span, best_dist = i, span, dist
      end
    end
  end

  if best == state.cur then return end  -- unchanged; skip the move
  state.cur = best
  if best then
    -- Only move when the outline cursor isn't already on the target line, to
    -- avoid redundant set_cursor calls (which cause redraw flicker).
    local cur_line = vim.api.nvim_win_get_cursor(state.win)[1]
    if cur_line ~= best then
      pcall(vim.api.nvim_win_set_cursor, state.win, { best, 0 })
    end
  end
end

-- Extract symbols for src_buf via tree-sitter and render them into the outline.
local function render(src_buf)
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then return end

  local set = function(text)
    vim.bo[state.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, text)
    vim.bo[state.buf].modifiable = false
    fit_width()
  end

  local out = { text = {}, kinds = {}, lines = {}, ranges = {} }

  local lang = ts.language.get_lang(vim.bo[src_buf].filetype)
  local ok, parser = pcall(ts.get_parser, src_buf, lang)
  local tree
  if ok and parser then
    -- parse() can throw on transient parser errors; render runs inside an
    -- autocmd, so keep the failure contained (falls back to (no parser)).
    local pok, res = pcall(function() return parser:parse()[1] end)
    tree = pok and res or nil
  end
  local extractor = lang and extractors[lang]

  local msg
  if not tree then
    msg = '(no parser)'            -- tree-sitter can't parse this buffer
  elseif not extractor then
    msg = '(no extractor)'        -- parses fine, but no symbol extractor
  end

  if msg then
    state.lines, state.ranges, state.cur = {}, {}, nil
    return set({ '  ' .. msg })
  end

  local records = {}
  extractor(tree:root(), src_buf, records)
  build(records, out, not NO_SEPARATORS[lang])
  if #out.text == 0 then out.text = { '  (no symbols)' } end  -- supported, empty

  state.lines, state.ranges, state.cur = out.lines, out.ranges, nil
  set(out.text)
  highlight_current()

  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
  for i, kind in ipairs(out.kinds) do
    local s = kind and out.text[i]:find('%S')
    if s then
      local label = KIND_LABEL[kind] or kind
      vim.api.nvim_buf_set_extmark(state.buf, ns, i - 1, s - 1, {
        end_col = s - 1 + #label, hl_group = 'OutlineKind_' .. kind,
      })
    end
  end
end

-- Sync the outline against whatever real source buffer is focused. Skips the
-- reparse when the same buffer is unchanged since the last render (changedtick),
-- so CursorHold on an idle buffer costs nothing.
local function refresh(force)
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then return end
  local win = vim.api.nvim_get_current_win()
  if win == state.win then return end
  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype ~= '' then return end
  -- Track the focused window even when we skip the reparse, so cursor-follow
  -- and jumps target the right split when the same buffer is shown in two.
  state.src_win = win
  local tick = vim.b[buf].changedtick
  if not force and buf == state.src_buf and tick == state.tick then return end
  state.src_buf, state.tick = buf, tick
  render(buf)
end

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

local function goto_symbol()
  local target = state.lines[vim.api.nvim_win_get_cursor(0)[1]]
  if not (target and state.src_win and vim.api.nvim_win_is_valid(state.src_win)) then return end
  vim.api.nvim_set_current_win(state.src_win)
  vim.api.nvim_win_set_cursor(state.src_win, { target[1] + 1, target[2] })
  vim.cmd('normal! zz')
end

local function open()
  local src_win = vim.api.nvim_get_current_win()
  local src_buf = vim.api.nvim_get_current_buf()

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.cmd('botright vertical ' .. MIN_WIDTH .. ' split')
  state.win = vim.api.nvim_get_current_win()
  state.src_win, state.src_buf, state.tick = src_win, src_buf, vim.b[src_buf].changedtick
  vim.api.nvim_win_set_buf(state.win, state.buf)

  local b = state.buf
  vim.bo[b].bufhidden, vim.bo[b].buftype = 'wipe', 'nofile'
  vim.bo[b].swapfile, vim.bo[b].buflisted = false, false
  vim.bo[b].filetype = 'outline'
  vim.api.nvim_buf_set_name(b, 'Outline')

  for opt, val in pairs({
    number = false, relativenumber = false, wrap = false, list = false,
    cursorline = true, signcolumn = 'no', colorcolumn = '', winfixwidth = true,
    -- Brighter cursorline just in this window (marks the current symbol),
    -- matching the colourscheme's cursorline hue but lifted for visibility.
    winhighlight = 'CursorLine:OutlineCursorLine',
  }) do vim.wo[state.win][opt] = val end

  vim.keymap.set('n', '<CR>', goto_symbol, { buffer = b, silent = true })
  vim.keymap.set('n', '<2-LeftMouse>', goto_symbol, { buffer = b, silent = true })

  render(src_buf)
end

vim.keymap.set('n', '<Leader>o', function()
  if state.win and vim.api.nvim_win_is_valid(state.win) then close() else open() end
end, { silent = true })

local group = vim.api.nvim_create_augroup('SymbolOutline', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
  group = group,
  callback = function() vim.schedule(function() refresh() end) end,
})
-- Re-extract on edits, but debounced: tree-sitter is fast, yet reparsing on
-- every keystroke is wasteful. CursorHold coalesces to when typing pauses, and
-- refresh() skips the reparse when the buffer is unchanged (changedtick).
vim.api.nvim_create_autocmd('CursorHold', {
  group = group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if win ~= state.win and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == '' then
      refresh()             -- reparses only if changed; a render also re-highlights
      highlight_current()   -- cheap; updates the marker when only the cursor moved
    end
  end,
})
-- Follow the cursor live, debounced. CursorMoved fires on every motion (and on
-- mouse clicks, which CursorHold may miss). highlight_current is cheap, but a
-- short debounce coalesces rapid motion into a single scan on large files.
local move_timer = vim.uv.new_timer()
vim.api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if win == state.win or vim.bo[vim.api.nvim_win_get_buf(win)].buftype ~= '' then return end
    if state.src_win ~= win then state.src_win = win end
    move_timer:stop()
    move_timer:start(40, 0, function()
      vim.schedule(function()
        if state.win and vim.api.nvim_win_is_valid(state.win) then highlight_current() end
      end)
    end)
  end,
})

-- Brighter cursorline for the outline window (marks the current symbol),
-- matching the colourscheme's cursorline hue but lifted for visibility.
vim.api.nvim_set_hl(0, 'OutlineCursorLine', { bg = '#33363b' })

-- Muted per-kind label colours (hybrid palette). The current symbol is shown
-- by the window's cursorline (the outline cursor follows the editor cursor).
local kind_colours = setmetatable({
  func = '#81a2be', meth = '#b5cc68', vmeth = '#b5cc68', imeth = '#b5cc68', constructor = '#b5cc68',
  struct = '#b294bb', type = '#b294bb', interface = '#7c5cbf',
  enum = '#b294bb', typeparam = '#b294bb', constraint = '#a3cfc4',
  const = '#de935f', var = '#cccc66', field = '#8abeb7', property = '#8abeb7',
  subtest = '#8abeb7',
  object = '#f0c674', array = '#8abeb7',
  string = '#b5cc68', number = '#de935f', bool = '#de935f', null = '#707880',
  ['package'] = '#f0c674', module = '#f0c674', namespace = '#f0c674',
  -- Markdown headings: monochrome blue, fading gently per level (matches the
  -- in-buffer heading colours in after/ftplugin/markdown.lua).
  h1 = '#8fb4d4', h2 = '#7fa2c0', h3 = '#7091ac',
  h4 = '#627f97', h5 = '#556d82', h6 = '#495c6d',
}, { __index = function() return '#707880' end })
for kind, fg in pairs(kind_colours) do
  vim.api.nvim_set_hl(0, 'OutlineKind_' .. kind, { fg = fg })
end
vim.api.nvim_set_hl(0, 'OutlineKind_other', { fg = '#707880' })
