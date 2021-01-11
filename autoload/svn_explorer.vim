
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
  let s:url .= getline('.')
  call s:show(s:url)
endfunction

function! svn_explorer#up() abort
endfunction

function! s:show(path) abort
  echom a:path
  let l:entries = systemlist('svn ls ' . a:path)

  setlocal modifiable
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
