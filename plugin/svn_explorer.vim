
augroup _svn_explorer_
  autocmd!
  autocmd BufEnter * call svn_explorer#init()
augroup END

command! -nargs=* -range=0 SvnExplorer  call svn_explorer#open(<f-args>)
