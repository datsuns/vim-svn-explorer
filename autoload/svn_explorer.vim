
function! svn_explorer#init() abort
  let s:url = ""
endfunction

function! svn_explorer#open(...) abort
  echom a:0
  if a:0 == 0
    let s:url = 'https://github.com/datsuns/vim-settings.git' 
  else
    let s:url = a:1
  endif
  call s:show(s:url)
endfunction

function! svn_explorer#down() abort
  let l:now = substitute(s:url, '/\+$', '', '')
  let s:url = l:now .'/' . getline('.')
  call s:show(s:url)
endfunction

function! svn_explorer#up() abort
  let l:now = substitute(s:url, '/\+$', '', '')
  let l:next = fnamemodify(l:now, ':h')
  if empty(l:next)
    return
  endif
  let s:url = l:next
  call s:show(s:url)
endfunction

function! s:show(path) abort
  "echom a:path
  let l:log = systemlist('svn ls ' . a:path)
  let l:entries = []
  for line in l:log
    let l:entries += [substitute(line, '\r', '', 'g')]
  endfor

  setlocal modifiable
  silent keepmarks keepjumps %delete _
  setlocal filetype=svn_explorer buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal nowrap cursorline

  silent keepmarks keepjumps call setline(1, sort(l:entries, function('s:sort')))

  setlocal nomodified nomodifiable
endfunction

function! s:sort(lhs, rhs) abort
  if a:lhs[-1:] ==# '/' && a:rhs[-1:] !=# '/'
    return -1
  elseif a:lhs[-1:] !=# '/' && a:rhs[-1:] ==# '/'
    return 1
  endif
  if a:lhs < a:rhs
    return -1
  elseif a:lhs > a:rhs
    return 1
  endif
  return 0
endfunction
