"
" The zlib license
"
" Copyright (c) 2015-2017 Victorien Elvinger
"
" This software is provided 'as-is', without any express or implied
" warranty. In no event will the authors be held liable for any damages
" arising from the use of this software.
"
" Permission is granted to anyone to use this software for any purpose,
" including commercial applications, and to alter it and redistribute it
" freely, subject to the following restrictions:
"
" 1. The origin of this software must not be misrepresented; you must not
"    claim that you wrote the original software. If you use this software
"    in a product, an acknowledgement in the product documentation would be
"    appreciated but is not required.
" 2. Altered source versions must be plainly marked as such, and must not be
"    misrepresented as being the original software.
" 3. This notice may not be removed or altered from any source distribution.
"


set history=100 " Command history length (Default: 10_000)

set textwidth=80 " Ideal maximum width of a line


" Backup
" ------

set backupskip+=/tmp/*,*/shm/*,*/playroom/*,*.swp,*.bak

" Persistent undo
set undofile " Enable persistent undo files
set undolevels=200 " Maximum number of undoing changes
set undoreload=8000 " Maximum number of lines to save for undo


" Colors
" ------

colorscheme Tomorrow-Night
set background=dark " Adapt colors to a dark background
set termguicolors " True color


" UI
" --

set lazyredraw " Redraw only when needed

set scrolloff=10 " Minimal number of lines to keep above and below the cursor
set sidescrolloff=10 " Minimal number of columns to keep horizontally

set nostartofline " Leave the cursor where it was for a bunch of commands

set showmatch " Matching brackets when the cursor is over them (similar to %)
set matchtime=2 " How many tenths of a second to blink when matching brackets

set nowrap " No line wrapping

set iskeyword=_,#,$,@,% " Are not word separators

set colorcolumn=+1 " Highlighting column "textwidth"+1
highlight ColorColumn ctermbg=darkgrey guibg=darkgrey

set cursorline " Highlight line where the cursor is

set showcmd " Show partial commands


" Line numbering
" --------------

set number " Absolute line numbering
set relativenumber " Relative line numbering

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber


" Status-line
" -----------

set statusline=%f " Path to the file
set statusline+=%= " Switch to the right side
set statusline+=%-10.{Paste_mode()}
set statusline+=%-8.{Indentation_practice()} " Indentation practice
set statusline+=%-6.(%c%V%)\%-4.(%P%) " Current Column


function! Indentation_practice()
    if &expandtab == 1
        return "Sp".&shiftwidth
    else
        return "Tab"
    endif
endfunction

function! Paste_mode()
    if &paste == 1
        return "Paste"
    else
        return ""
    endif
endfunction


" Searching
" ---------

set ignorecase " Case-insensitive search
set smartcase " Use case-sensitive search when a capital is present


" Auto-completion
" ---------------
" Customize <Tab> completion

set complete+=kspell " Spell auto-completion when spell is enabled
set infercase " Case-sensitive auto-completion


" Indentation and whitespace
" --------------------------

filetype indent plugin on

set copyindent " Copy indetation of the previous line
set smartindent " Better auto-indentation for C-like syntax

set shiftround " Absorb space when tab is used
set shiftwidth=4 " Number of inserted columns by the indent operation
set softtabstop=4 " Number of inserted columns when <Tab> is hit for indenting
set tabstop=4 " Number of columns for a Tab


set list listchars=tab:» ,trail:•,nbsp:·
    " Show tabs, trailing and non-breaking spaces

highlight SpecialKey term=bold ctermfg=red guifg=red
    " Color for "nbsp", "space", "tab", and "trail" from "listchars"


set expandtab

function! Infer_indentation_practice()
    " Infer indentation practice (tabs or 2/4 spaces)
    " based on first 800 lines

    let header=getline(1,800)
    if match(header,"^\t", 0, 1) != -1
        " Use tabs for indenting
        set noexpandtab
    elseif match(header,"^[ ][ ][^ ]", 0, 1) != -1
        " Use 2 spaces for indenting
        set shiftwidth=2
        set softtabstop=2
    else
        " Use 4 spaces for indenting
    endif
endfunction

autocmd BufReadPost * call Infer_indentation_practice()
    " Infer indentation practice when opening a file (before "modelines")


" key mapping
" -----------

nnoremap Y y$
    " default: "Y" acts as "yy"
    " Same behavior as D and C

cnoremap w!! w !sudo tee > /dev/null %
    " Wwrite in sudo

set pastetoggle=<F2>
    " Toggle between nopaste and paste mode
    " Paste mode prevents indenting

vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
    " Copy to clipboard
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
    " Paste from clipboard


" POSIX regex
" -----------

nnoremap / /\v
vnoremap / /\v
nnoremap :g/ :g/\v


" File type
" ---------

filetype on
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.rs set filetype=rust
autocmd BufNewFile,BufRead *.ts,*.tsx set filetype=typescript
