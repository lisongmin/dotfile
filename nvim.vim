
set hidden
colorscheme ron

" Set map leader
let mapleader = ","

tnoremap <Esc> <C-\><C-n>
tnoremap <C-]> <C-\><C-n>

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" -----------------------------
" TAB setting
" -----------------------------
" Set 4 spaces per tab default.
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" load indent by .editorconfig.
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" use tab or space according to contents.
Plug 'conormcd/matchindent.vim'

Plug 'sourcegraph/javascript-typescript-langserver', {'do': 'npm install && npm run build'}
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'python': ['pyls'],
    \ 'javascript': ['node', '~/.local/share/nvim/plugged/javascript-typescript-langserver/lib/language-server-stdio'],
    \ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'
Plug 'zchee/deoplete-jedi'

" rust highlighting, format etc.
Plug 'rust-lang/rust.vim'
" dockfile syntax
Plug 'ekalinin/Dockerfile.vim'

Plug 'Shougo/neco-vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=["UltiSnips", 'mysnips']
let g:snips_author = 'Song min.Li (Li)'
let g:snips_email = 'lsm@skybility.com'
let g:snips_github = ''
let g:snips_company = 'Skybility Software Co.,Ltd.'

Plug 'vim-scripts/a.vim'
let g:alternateSearchPath = 'wdr:src,wdr:include,reg:|src/\([^/]\)|include/\1||,reg:|include/\([^/]\)|src/\1||'

" ----------------------------
"  file operation
"  ---------------------------
" quick open file
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" switch fcitx to en mode in normal mode.
Plug 'lilydjwg/fcitx.vim'

" Initialize plugin system
call plug#end()

" strip tail space.
autocmd BufWritePre * :%s/\s\+$//e
