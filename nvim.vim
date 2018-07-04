
set hidden
colorscheme ron

" Set map leader
let mapleader = ","

tnoremap <Esc> <C-\><C-n>
tnoremap <C-]> <C-\><C-n>

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

"----------------------------------------------------------->
"<< file encoding >>
"----------------------------------------------------------->
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,cp936
scriptencoding utf-8

" -----------------------------
" TAB setting
" -----------------------------
" Set 4 spaces per tab default.
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" git manager
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" file explorer
Plug 'tpope/vim-vinegar'
" file / buffer search
Plug 'Shougo/denite.nvim'

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

    let l:matched = len(l:value)
    if l:matched <= 0
        return ''
    endif

    " remove inserted chars before expand snippet
    if col('.') == col('$')
        let l:matched -= 1
        exec 'normal! ' . l:matched . 'Xx'
    else
        exec 'normal! ' . l:matched . 'X'
    endif

    if col('.') == col('$') - 1
        " move to $ if at the end of line.
        call cursor(line('.'), col('$'))
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
" \   'markdown': ['prettier'],
"\   'css': ['prettier'],
"\   'json': ['prettier'],
"\   'scss': ['prettier'],
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
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
autocmd FileType typescript JsPreTmpl
autocmd FileType typescript syn clear foldBraces
augroup END

Plug 'pboettch/vim-cmake-syntax'

" Initialize plugin system
call plug#end()
