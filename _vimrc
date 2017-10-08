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

set noeb vb t_vb=
au GuiEnter * set t_vb=

" Not break line when line is out of the window.
set nowrap

" Set map leader
let mapleader = ","

" Set color scheme
colo morning "ron
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

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
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

" tell vim do not indent when type : in yaml.
autocmd FileType yaml setl indentkeys-=<:>

"----------------------------------------------------------->
"<< file encoding >>
"----------------------------------------------------------->
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,cp936
"set ambiwidth=double
if has("gui_running")
    if ! has("win32")
        " set font
        " set gfn=DejaVu\ Sans\ Mono\ 8
        "set gfn=DejaVu\ Sans\ Mono\ 12
        "colo morning
    endif
endif

"------------------------------------------->
" Bundle begin
" ------------------------------------------>
filetype off                   " required!

set rtp+=~/.vim/vim-plug/plug.vim
call plug#begin('~/.vim/bundle')

Plug 'will133/vim-dirdiff'

" switch fcitx to en mode in normal mode.
Plug 'lilydjwg/fcitx.vim'

" git manager
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdcommenter'
" python complete
" -- <leader>r - rename
" -- <leader>d - definations
"  - <leader>g - assignments
"  - <K>       - show pydoc
"  - <leader>n - related names
Plug 'davidhalter/jedi-vim'
let g:jedi#completions_command = "<C-N>"
Plug 'hynek/vim-python-pep8-indent'

Plug 'scrooloose/syntastic'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

" ctags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = '/tmp/tags/'

" YCM for completions
Plug 'Valloric/YouCompleteMe', { 'do': 'python ./install.py --clang-completer --system-libclang --system-boost' }
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_filetype_whitelist = {'c': 1, 'cpp': 1, 'python': 1,
            \ 'typescript': 1, 'javascript': 1}
let g:ycm_keep_logfiles = 0
nnoremap <F4> :YcmDiags<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <Leader>] :YcmCompleter GoTo<CR>
nnoremap <Leader>gh :YcmCompleter GoToInclude<CR>
nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <Leader>gc :YcmCompleter GoToDeclaration<CR>

nnoremap <Leader>gt :YcmCompleter GetType<CR>
nnoremap <Leader>gf :YcmCompleter FixIt<CR>
nnoremap <Leader>gp :YcmCompleter GetParent<CR>
nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=["UltiSnips", 'mysnips']
let g:snips_author = 'Song min.Li (Li)'
let g:snips_email = 'lsm@skybility.com'
let g:snips_github = ''
let g:snips_company = 'Skybility Software Co.,Ltd.'

Plug 'vim-scripts/a.vim'
let g:alternateSearchPath = 'wdr:src,wdr:include,reg:|src/\([^/]\)|include/\1||,reg:|include/\([^/]\)|src/\1||'

" markdown support
Plug 'mattn/calendar-vim'
Plug 'lisongmin/vimwiki'
let g:vimwiki_list = [
            \ {'path': '~/mywiki',
            \ 'index': 'index.html',
            \ 'syntax': 'markdown', 'ext': '.md'
            \ }
            \ ]

let g:vimwiki_ext2syntax = {'.md': 'markdown',
                  \ '.mkd': 'markdown',
                  \ '.wiki': 'media'}

let g:vimwiki_nested_syntaxes = {'python': 'python', 'graphviz': 'dot', 'dot': 'dot', 'c++': 'cpp', 'bash': 'sh'}
let g:vimwiki_CJK_length = 1

:autocmd FileType vimwiki nmap <leader>wn :VimwikiMakeDiaryNote<CR>
function! ToggleCalendar()
    execute ":Calendar"
    if exists("g:calendar_open")
        if g:calendar_open == 1
            execute "q"
            unlet g:calendar_open
        else
            g:calendar_open = 1
        end
    else
        let g:calendar_open = 1
    end
endfunction
:autocmd FileType vimwiki nmap <leader>wc :call ToggleCalendar()<CR>

" quick open file
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

Plug 'lisongmin/markdown2ctags'
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
"let g:tagbar_autoshowtag = 1
"
let g:tagbar_type_tex = {
            \ 'ctagstype' : 'latex',
            \ 'kinds' : [
            \'p:part',
            \'c:chapter',
            \'s:section',
            \'u:subsection',
            \'b:subsubsection',
            \'P:paragragh',
            \'G:subparagragh',
            \'l:label',
            \]
            \}

" jump begin xml/tex tag
Plug 'vim-scripts/matchit.zip'


" load indent by .editorconfig.
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" use tab or space according to contents.
Plug 'conormcd/matchindent.vim'

"神级插件，ZenCoding可以让你以一种神奇而无比爽快的感觉写HTML、CSS
Plug 'vim-scripts/ZenCoding.vim'

Plug 'bling/vim-airline'
let g:airline_powerline_fonts = 1
set t_Co=256
set laststatus=2
" let g:airline_gitblame_enalbe = 1

" typescript
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/vim-js-pretty-template'
autocmd FileType typescript JsPreTmpl html
autocmd FileType typescript syn clear foldBraces
Plug 'Shougo/vimproc.vim'
Plug 'Quramy/tsuquyomi'

Plug 'pboettch/vim-cmake-syntax'

call plug#end()            " required
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
