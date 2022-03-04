"----------------------------------------------------------->
"<< file encoding >>
"----------------------------------------------------------->
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,cp936
scriptencoding utf-8

"---------------------------------------------------------->
"<< General option >>
"---------------------------------------------------------->
set modelines=0
set nomodeline

set hlsearch
set incsearch

set noerrorbells vb t_vb=
augroup NO_BELLS
  au GuiEnter * set t_vb=
augroup END

" Not break line when line is out of the window.
set nowrap

" Set map leader
let g:mapleader = ','

let g:vim_cache_path = stdpath('cache')
let g:vim_data_path = stdpath('data')

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    " Create dirs
    let g:undo_dir = g:vim_cache_path . '/undo'
    call mkdir(g:undo_dir, 'p', '0750')
    let &undodir = g:undo_dir
    set undofile
endif

"------------------------------------------->
" Bundle begin
" ------------------------------------------>
filetype off                   " required!

let g:vim_plug_path = g:vim_data_path . '/plugged'
call mkdir(g:vim_plug_path, 'p', '0750')
call plug#begin(g:vim_plug_path)

Plug 'will133/vim-dirdiff'

" git manager
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" moving
Plug 'asvetliakov/vim-easymotion'
map <Leader> <Plug>(easymotion-prefix)

" markdown support
Plug 'godlygeek/tabular'

" jump begin xml/tex tag
Plug 'vim-scripts/matchit.zip'

"神级插件，Emmet可以让你以一种神奇而无比爽快的感觉写HTML、CSS
Plug 'mattn/emmet-vim'

call plug#end()            " required
