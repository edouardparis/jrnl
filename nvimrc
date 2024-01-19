" insert fancy signifiers with abbrevs
iabbrev todo ·
iabbrev done ×

set fillchars=eob:\ 
" select the task list and hit `gq` to sort and group by status
set formatprg=sort\ -V

" syntax highlighting
augroup JournalSyntax
    autocmd!
    autocmd BufReadPost * set filetype=journal

    autocmd BufReadPost * syntax match JournalAll /.*/                 " captures the entire buffer
    autocmd BufReadPost * syntax match JournalDone /^×.*/              " lines containing 'done' items:  ×
    autocmd BufReadPost * syntax match JournalTodo /^·.*/              " lines containing 'todo' items:  ·
    autocmd BufReadPost * syntax match JournalEvent /^o.*/             " lines containing 'event' items: o
    autocmd BufReadPost * syntax match JournalNote /^- .*/             " lines containing 'note' items:  -
    autocmd BufReadPost * syntax match JournalMoved /^>.*/             " lines containing 'moved' items: >
    autocmd BufReadPost * syntax match JournalHeader /^\<\u\+\>.*/     " lines starting with caps

    autocmd BufReadPost * highlight JournalAll    ctermfg=8
    autocmd BufReadPost * highlight JournalHeader ctermfg=8
    autocmd BufReadPost * highlight JournalDone   ctermfg=8
    autocmd BufReadPost * highlight JournalEvent  ctermfg=6               " cyan
    autocmd BufReadPost * highlight JournalMoved  ctermfg=5               " pink
    autocmd BufReadPost * highlight JournalNote   ctermfg=3               " yellow
    autocmd BufReadPost * highlight VertSplit     ctermfg=0  ctermbg=0    " hide vert splits
augroup END

augroup JournalHideUIElements
    autocmd!
    " hide junk
    autocmd VimEnter * set laststatus=0
    autocmd VimEnter * set noruler nonumber nocursorline nocursorcolumn norelativenumber

    " pin scrolling
    autocmd VimEnter * set scrollbind

augroup END
