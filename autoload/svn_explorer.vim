
function! svn_explorer#init() abort
endfunction

function! svn_explorer#open(...) abort
  echom a:0
  if a:0 == 0
    let l:path = 'https://github.com/datsuns/vim-settings.git' 
  else
    let l:path = a:1
  endif
  let l:path .= '/'
  call s:show(l:path)
endfunction

function! svn_explorer#down() abort
  if !s:valid_pos()
    return
  endif

  let l:next = s:gen_child_url()
  call s:show(l:next)
endfunction

function! svn_explorer#up() abort
  if !s:valid_pos()
    return
  endif

  let l:next = s:gen_up_url()
  if empty(l:next)
    return
  endif
  let l:next .= '/'
  call s:show(l:next)
endfunction

function! s:show(url) abort
  "echom a:url
  if a:url[len(a:url) - 1] == '/'
    call s:show_path(a:url)
  else
    call s:show_file(a:url)
  endif
endfunction

function! s:valid_pos() abort
  let pos = getpos('.')
  if pos[1] < 3
    return v:false
  else
    return v:true
  endif
endfunction

function! s:load_url() abort
  return getline(1)
endfunction

function! s:gen_child_url() abort
  let l:now = substitute(s:load_url(), '/\+$', '', '')
  let l:next = l:now .'/' . getline('.')
  return l:next
endfunction

function! s:gen_up_url() abort
  let l:now = substitute(s:load_url(), '/\+$', '', '')
  let l:next = fnamemodify(l:now, ':h')
  return l:next
endfunction

function! s:show_path(path) abort
  let l:log = systemlist('svn ls ' . a:path)
  let l:entries = []
  for line in l:log
    let l:entries += [substitute(line, '\r', '', 'g')]
  endfor

  setlocal modifiable
  silent keepmarks keepjumps %delete _
  setlocal filetype=svn_explorer buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal nowrap cursorline

  silent keepmarks keepjumps call setline(1, a:path)
  silent keepmarks keepjumps call setline(2, "================================")

  silent keepmarks keepjumps call setline(3, sort(l:entries, function('s:sort')))
  call cursor(3, 0)

  setlocal nomodified nomodifiable
endfunction

function! s:show_file(path) abort
  let l:name = fnamemodify(a:path, ':t')
  let l:ft = fnamemodify(a:path, ':e')
  if len(l:ft) == 0
    let l:ft = l:name
  endif
  let l:log = systemlist('svn cat ' . a:path)

  execute ':tabnew'
  setlocal modifiable
  silent keepmarks keepjumps call setline(1, l:log)
  execute ':set ft=' . l:ft
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
