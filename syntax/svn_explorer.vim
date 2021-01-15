if exists('b:current_syntax')
  finish
endif

syn match svnExplorerHeaderDelimiter '^=\+$'
syn match svnExplorerDirectory '^.\+/$'

hi! def link svnExplorerDirectory Directory
hi! def link svnExplorerHeaderDelimiter Comment

let b:current_syntax = 'svn_explorer'
