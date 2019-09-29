
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
" Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = '/tmp/tags-nvim-' . expand('$USER')
" let g:gutentags_trace = 1

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'mysnips']
let g:snips_author = 'Songmin Li (Li)'
let g:snips_email = 'lsm@skybility.com'
let g:snips_github = ''
let g:snips_company = 'Skybility Software Co.,Ltd.'
" disable ultisnips's default key bind in favote of coc-ultisnips
let g:UltiSnipsJumpForwardTrigger =          '<c-z><c-j>'
let g:UltiSnipsJumpBackwardTrigger =         '<c-z><c-k>'

" ============================
" completions
" ============================

Plug 'neoclide/coc.nvim', {'branch': 'release'}

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

Plug 'vim-scripts/a.vim'
let g:alternateSearchPath = 'wdr:src,wdr:include,reg:|src/\([^/]\)|include/\1||,reg:|include/\([^/]\)|src/\1||'

" markdown support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1

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
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_cpp_clangtidy_checks = ['*', '-cppcoreguidelines-pro-type-vararg', '-google-runtime-references', '-google-readability-todo', '-objc-*', '-mpi-*', '-fuchsia-*', '-android-*', '-llvm-*']
let g:ale_c_clangformat_options = '-style=file -assume-filename=a.c'
let g:ale_cpp_clangformat_options = '-style=file -assume-filename=a.cpp'
if &diff
    let g:ale_fix_on_save = 0
endif
" shfmt: download from https://github.com/mvdan/sh/releases/download/v2.4.0/shfmt_v2.4.0_linux_amd64
" c/c++: pacman -S clang
" \   'c': ['clang', 'clangtidy', 'clang-format', ],
" \   'cpp': ['clang', 'clangtidy', 'clang-format'],
" eslint: pacman -S eslint
" vim-vint: pip install --user vim-vint
" prettier: pacman -S prettier
" csslint: yarn global add csslint
" tidy: pacman -S tidy
" alex: pacman -S alex
" yamllint: pacman -S yamllint
" xmllint: pacman -S libxml2 (already installed default)
" tslint: yarn global add tslint
" java: yay -S checkstyle
let g:ale_linters = {
\   'bash': ['shfmt'],
\   'c': ['clangtidy'],
\   'cpp': ['clangtidy'],
\   'javascript': ['eslint'],
\   'vim': ['vint'],
\   'css': ['csslint'],
\   'html': ['alex', 'tidy'],
\   'markdown': ['alex'],
\   'python': ['flake8', 'pylint'],
\   'tex': ['chktex'],
\   'typescript': ['eslint', 'tslint'],
\   'xml': ['alex', 'xmllint'],
\   'yaml': ['yamllint'],
\   'java': ['checkstyle'],
\}

" \   'bash': ['shfmt'],
" \   'typescript': ['eslint', 'tslint'],
" \   'javascript': ['eslint'],
" \   'markdown': ['prettier'],
"\   'css': ['prettier'],
"\   'scss': ['prettier'],
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'python': ['autopep8'],
\   'rust': ['rustfmt'],
\   'typescript': ['tslint'],
\   'java': ['google-java-format'],
\   'xml': ['xmllint'],
\   'json': ['prettier'],
\   'bash': ['shfmt']
\}

au BufEnter * let b:ale_xml_xmllint_indentsize = &softtabstop

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

call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('grep',     'command', ['rg'])
call denite#custom#var('grep',     'default_opts', ['--hidden', '--vimgrep', '--no-heading', '-S'])
call denite#custom#var('grep',     'recursive_opts', [])
call denite#custom#var('grep',     'final_opts',   [])
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
nnoremap <leader>f :<C-u>Denite file_rec<cr>
nnoremap <leader>s :<C-u>Denite grep<cr>
nnoremap <leader>b :<C-u>Denite buffer<cr>
nnoremap <leader>o :<C-u>Denite outline<cr>

