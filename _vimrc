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

set noerrorbells vb t_vb=
au GuiEnter * set t_vb=

" Not break line when line is out of the window.
set nowrap

" Set map leader
let g:mapleader = ','

" Set color scheme
colo morning "ron
if has('gui_running')
    colo evening
endif

" Auto reload while the file is changed from the outside
set autoread

" 切换时自动保存
set autowrite
" 切换时隐藏
set hidden

" Disable menu and toolbar
if has('gui_running')
    "去掉菜单、工具栏、滚动条
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guiheadroom=0
endif

" Put plugins and dictionaries in this dir (also on Windows)
let g:vimDir = '$HOME/.vim'
let &runtimepath .= ',' . g:vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let g:myUndoDir = expand(g:vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . g:vimDir)
    call system('mkdir ' . g:myUndoDir)
    let &undodir = g:myUndoDir
    set undofile
endif

"----------------------------------------------------------->
"<< indent >>
"----------------------------------------------------------->
set autoindent
set smartindent
set cindent

"set ambiwidth=double
if has('gui_running')
    if ! has('win32')
        " set font
        " set gfn=DejaVu\ Sans\ Mono\ 8
        "set gfn=DejaVu\ Sans\ Mono\ 12
        "colo morning
        "set gfn=Fira\ Code
    endif
endif

"------------------------------------------->
" Bundle begin
" ------------------------------------------>
filetype off                   " required!

set runtimepath+=~/.vim/vim-plug/plug.vim
call plug#begin('~/.vim/bundle')

Plug 'will133/vim-dirdiff'

" switch fcitx to en mode in normal mode.
Plug 'lilydjwg/fcitx.vim'

" git manager
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" ctags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = '/tmp/tags/'

" ============================
" completions
" ============================
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_settingsPath = expand('~/dotfile/language-client-settings.json')
" yarn global add bash-language-server
" pacman -S cquery
" yarn global add javascript-typescript-langserver
" pip install --user python-language-server
let g:LanguageClient_serverCommands = {
    \ 'sh': ['bash-language-server', 'start'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ 'cpp': ['cquery', '--language-server', '--log-file=/tmp/cq.log']
    \ }
let g:LanguageClient_rootMarkers = {
    \ 'cpp': ['.cquery', 'compile_commands.json', 'build'],
    \ }
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" (Optional) Multi-entry selection UI.
" pacman -S fzf
Plug 'junegunn/fzf.vim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'mysnips']
let g:snips_author = 'Songmin Li (Li)'
let g:snips_email = 'lsm@skybility.com'
let g:snips_github = ''
let g:snips_company = 'Skybility Software Co.,Ltd.'

function! ExpandLspSnippet()
    call UltiSnips#ExpandSnippetOrJump()
    if !pumvisible() || empty(v:completed_item)
        return ''
    endif

    " only expand Lsp if UltiSnips#ExpandSnippetOrJump not effect.
    let l:value = v:completed_item['word']
    let l:kind = v:completed_item['kind']
    let l:abbr = v:completed_item['abbr']

    " remove inserted chars before expand snippet
    let l:end = col('.')
    let l:line = 0
    let l:start = 0
    for l:match in [l:abbr . '(', l:abbr, l:value]
        let [l:line, l:start] = searchpos(l:match, 'b', line('.'))
        if l:line != 0 || l:start != 0
            break
        endif
    endfor
    if l:line == 0 && l:start == 0
        return ''
    endif

    let l:matched = l:end - l:start
    if l:matched <= 0
        return ''
    endif

    exec 'normal! ' . l:matched . 'x'

    if col('.') == col('$') - 1
        " move to $ if at the end of line.
        call cursor(l:line, col('$'))
    endif

    " expand snippet now.
    call UltiSnips#Anon(l:value)
    return ''
endfunction

imap <C-k> <C-R>=ExpandLspSnippet()<CR>


Plug 'vim-scripts/a.vim'
let g:alternateSearchPath = 'wdr:src,wdr:include,reg:|src/\([^/]\)|include/\1||,reg:|include/\([^/]\)|src/\1||'

" markdown support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1

" quick open file
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

Plug 'lisongmin/markdown2ctags'

" ================================
" indent config
" ================================

" jump begin xml/tex tag
Plug 'vim-scripts/matchit.zip'

" load indent by .editorconfig.
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" use tab or space according to contents.
Plug 'conormcd/matchindent.vim'

" format
Plug 'Chiel92/vim-autoformat'
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
augroup autoformat
autocmd FileType javascript,ts let b:autoformat_autoindent=1
autocmd FileType javascript,ts let b:autoformat_retab=1
if ! &diff
    au BufWrite *.js,*.ts :Autoformat
endif
augroup END

noremap <F3> :Autoformat<CR>
" ================================
" indent config end.
" ================================

" ================================
" lint and fixer.
" ================================
Plug 'w0rp/ale'
let g:ale_linters_explicit = 1
let g:ale_open_list = 1
let g:ale_fix_on_save = 1
let g:ale_warn_about_trailing_whitespace = 0
" shfmt: download from https://github.com/mvdan/sh/releases/download/v2.4.0/shfmt_v2.4.0_linux_amd64
" c/c++: pacman -S flawfinder cppcheck clang
" \   'c': ['clang', 'clangtidy', 'clang-format', 'flawfinder', 'cppcheck'],
" \   'cpp': ['clang', 'clangtidy', 'clang-format', 'flawfinder', 'cppcheck'],
" eslint: pacman -S eslint
" vim-vint: pip install --user vim-vint
" prettier: pacman -S prettier
" csslint: yarn global add csslint
" tidy: pacman -S tidy
" alex: pacman -S alex
" yamllint: pacman -S yamllint
" xmllint: pacman -S libxml2 (already installed default)
" tslint: yarn global add tslint
let g:ale_linters = {
\   'bash': ['shfmt'],
\   'c': ['clangtidy'],
\   'cpp': ['clangtidy'],
\   'javascript': ['eslint'],
\   'vim': ['vint'],
\   'css': ['csslint'],
\   'html': ['alex', 'tidy'],
\   'markdown': ['alex'],
\   'python': ['flake8'],
\   'tex': ['chktex'],
\   'typescript': ['eslint', 'tslint'],
\   'xml': ['alex', 'xmllint'],
\   'yaml': ['yamllint']
\}

" \   'bash': ['shfmt'],
" \   'typescript': ['eslint', 'tslint'],
" \   'javascript': ['eslint'],
let g:ale_fixers = {
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'css': ['prettier'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'scss': ['prettier'],
\   'python': ['autopep8'],
\   'vim': ['trim_whitespace'],
\   'tex': ['trim_whitespace'],
\   'xml': ['trim_whitespace'],
\   'yaml': ['trim_whitespace'],
\   'toml': ['trim_whitespace'],
\}

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
augroup typescript
autocmd FileType typescript JsPreTmpl html
autocmd FileType typescript syn clear foldBraces
augroup END

Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'

Plug 'pboettch/vim-cmake-syntax'

call plug#end()            " required
" Enable file type plugin and indent
filetype plugin indent on
"-------------------------------------------<
" Bundle end
" ------------------------------------------<

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
    let $TEXINPUTS = ':.:/tmp'
endif
let g:tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'
let g:tlist_make_settings  = 'make;m:makros;t:targets'

"----------------------------------------------------------->
"<< xml folding >>
"----------------------------------------------------------->
let g:xml_syntax_folding=0
