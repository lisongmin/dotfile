"---------------------------------------------------------->
"<< General option >>
"---------------------------------------------------------->

" Get out of Vi's compatible mode.
set nocompatible

set shell=bash

" Enable syntax highline
syntax on
set hlsearch

" Set 4 spaces per tab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
if &diff
    set list
endif

" Not break line when line is out of the window.
set nowrap

" Set map leader
let mapleader = ","

" Set color scheme
colo ron
if has('gui_running')
    colo evening
endif

" Auto reload while the file is changed from the outside
set autoread

" 切换时自动保存
set aw
" 切换时隐藏
set hid

" Reload .vimrc when the .vimrc file changed
if has('win32')
    autocmd! bufwritepost vimrc source ~/_vimrc
else
    autocmd! bufwritepost vimrc source ~/.vimrc
endif

" Disable menu and toolbar
if has("gui_running")
    "去掉菜单、工具栏、滚动条
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guiheadroom=0
endif

" 设置swp文件保存路径
"if has('win32')
"    set dir=%tmp%
"else
"    set dir=/tmp
"endif

"----------------------------------------------------------->
"<< indent >>
"----------------------------------------------------------->
set ai
set si
set autoindent
set cindent
"----------------------------------------------------------->
" 设置c/c++的缩进格式
"----------------------------------------------------------->
set cinoptions=:0,g0

"----------------------------------------------------------->
"去掉行尾空格
"----------------------------------------------------------->
autocmd BufWritePre * :%s/\s\+$//e

"----------------------------------------------------------->
"<< file encoding >>
"----------------------------------------------------------->
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,cp936
"set ambiwidth=double
if has("gui_running")
    if ! has("win32")
        set gfn=DejaVu\ Sans\ Mono\ 8
    endif
endif

"------------------------------------------->
" Bundle begin
" ------------------------------------------>
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" git manager
Plugin 'tpope/vim-fugitive'

" python complete
" -- <leader>r - rename
" -- <leader>d - definations
"  - <leader>g - assignments
"  - <K>       - show pydoc
"  - <leader>n - related names
Plugin 'davidhalter/jedi-vim'
let g:jedi#completions_command = "<C-N>"

" rust language
Plugin 'rust-lang/rust.vim'
" <leader>gd -- go to definations
Plugin 'racer-rust/vim-racer'
let g:racer_cmd = "~/.vim/bundle/racer/target/release/racer"
let $RUST_SRC_PATH="~/.vim/bundle/rust/src/"

Plugin 'scrooloose/syntastic'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

" haskell language
Plugin 'raichoo/haskell-vim'

" YCM for completions
Plugin 'Valloric/YouCompleteMe'
let g:ycm_extra_conf_globlist = ['/work/*']
let g:ycm_key_list_select_completion = ['<Enter>']
let g:ycm_key_list_previous_completion = []

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'brookhong/cscope.vim'
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
if has('win32')
    nmap <leader>cs :!dir /S /b *.h *.c *.ipp *.hpp *.cpp *.java > cscope.files<CR>:!cscope -bkq -i cscope.files<CR>:cs add cscope.out<CR>
else
    nmap <leader>cs :!find ./ -name "*.h" -o -name "*.c" -o -name "*.ipp" -o -name "*.hpp" -o -name "*.cpp" -o -name "*.java" > cscope.files<CR>:!cscope -bkq -i cscope.files<CR>:cs add cscope.out<CR>:cs reset<CR>
endif

Plugin 'a.vim'
let g:alternateSearchPath = 'wdr:src,wdr:include,reg:|src/\([^/]\)|include/\1||,reg:|include/\([^/]\)|src/\1||'

" markdown support
Plugin 'vimwiki'
let g:vimwiki_list = [{'path': '~/mywiki',
      \ 'index' : 'index.html',
      \ 'syntax' : 'markdown', 'ext' : '.md'}]

let g:vimwiki_ext2syntax = {'.md': 'markdown',
                  \ '.mkd': 'markdown',
                  \ '.wiki': 'media'}

let g:vimwiki_CJK_length = 1

" quick open file
Plugin 'L9'
Plugin 'FuzzyFinder'
command! Fe : FufFile
command! Fc : FufFileWithCurrentBufferDir
command! Fb : FufBuffer

Plugin 'taglist.vim'

" jump begin xml/tex tag
Plugin 'matchit.zip'

" use tab or space according to contents.
Plugin 'conormcd/matchindent.vim'

"神级插件，ZenCoding可以让你以一种神奇而无比爽快的感觉写HTML、CSS
Plugin 'ZenCoding.vim'

Plugin 'bling/vim-airline'
let g:airline_powerline_fonts = 1
set t_Co=256
set laststatus=2
" let g:airline_gitblame_enalbe = 1

call vundle#end()            " required
" Enable file type plugin and indent
filetype plugin indent on
"-------------------------------------------<
" Bundle end
" ------------------------------------------<

"----------------------------------------------------------->
"<< astyle setting >>
"----------------------------------------------------------->
autocmd filetype cpp set formatprg=!astyle\ -s4bfjpHUk1
autocmd filetype c set formatprg=!astyle\ -s4bfjpHk1
map <leader>gq :gggqG

"----------------------------------------------------------->
"<< Latex setting.
"----------------------------------------------------------->
if has('win32')
    map <leader>xx :!xelatex -halt-on-error -shell-escape -output-directory=\%tmp\% "%:p"<CR>:!xelatex -halt-on-error -shell-escape -output-directory=\%tmp\% "%:p"<CR>
    map <leader>xe :!evince \%tmp\%."/%:t:r.pdf"&<CR><CR>
    map <leader>vz :!dot -Tps2 "%:t:r.dot" -o "%:t:r.eps" &<CR><CR>:!ps2pdf "%:t:r.eps" \%tmp\%."/%:t:r.pdf"& <CR><CR>
    "map <leader>vz :!dot -Tpng "%:t:r.dot" -o \%tmp\% . "%:t:r.png" &<CR><CR>
    "map <leader>ve :!eog \%tmp\% . "/%:t:r.png" &<CR><CR>
else
    map <leader>xx :!xelatex -halt-on-error -shell-escape -output-directory=/tmp "%:p"<CR>:!xelatex -halt-on-error -shell-escape -output-directory=/tmp "%:p"<CR>
    map <leader>xe :!evince "/tmp/%:t:r.pdf"&<CR><CR>
    map <leader>vz :!dot -Tps2 "%:t:r.dot" -o "/tmp/%:t:r.eps" &<CR><CR>:!ps2pdf "/tmp/%:t:r.eps" "/tmp/%:t:r.pdf"& <CR><CR>
    let $TEXINPUTS = ":.:/tmp"
endif
let tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'
let tlist_make_settings  = 'make;m:makros;t:targets'

"----------------------------------------------------------->
"<< xml folding >>
"----------------------------------------------------------->
let g:xml_syntax_folding=0
