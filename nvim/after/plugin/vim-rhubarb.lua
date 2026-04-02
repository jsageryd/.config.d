-- Use short commit hash in :GBrowse URLs
vim.cmd [[
  function! ShortenCommitForBrowse(opts) abort
    if has_key(a:opts, 'commit') && a:opts.commit =~# '^\x\{40,\}$'
      let a:opts.commit = a:opts.commit[:15]
    endif
    return rhubarb#FugitiveUrl(a:opts)
  endfunction

  if exists('g:fugitive_browse_handlers')
    call filter(g:fugitive_browse_handlers, 'v:val isnot# function("rhubarb#FugitiveUrl")')
    call insert(g:fugitive_browse_handlers, function('ShortenCommitForBrowse'))
  endif
]]
