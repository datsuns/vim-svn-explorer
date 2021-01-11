if exists('b:current_syntax')
  finish
endif

syn match svnExplorerDirectory '^.\+/$'
hi! def link svnExplorerDirectory Directory

let b:current_syntax = 'svn_explorer'
