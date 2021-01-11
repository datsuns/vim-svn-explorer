nnoremap <plug>(svn-explorer-down) :<c-u>call svn_explorer#down()<cr>
nnoremap <plug>(svn-explorer-up) :<c-u>call svn_explorer#up()<cr>

if !hasmapto('<plug>(svn-explorer-down)')
  nmap <buffer> <cr> <plug>(svn-explorer-down)
endif
if !hasmapto('<plug>(svn-explorer-up)')
  nmap <buffer> - <plug>(svn-explorer-up)
endif
