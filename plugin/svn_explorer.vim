
augroup _svn_explorer_
  autocmd!
  autocmd BufEnter * call svn_explorer#init()
augroup END
