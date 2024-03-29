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

set shell=bash

" Enable syntax highline
syntax on
set hlsearch
set incsearch

" Set 4 spaces per tab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
if &diff
    set list
endif

set noerrorbells vb t_vb=
augroup NO_BELLS
  au GuiEnter * set t_vb=
augroup END

" Not break line when line is out of the window.
set nowrap

" Set map leader
let g:mapleader = ','

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

if has('nvim')
  let g:vim_cache_path = stdpath('cache')
  let g:vim_data_path = stdpath('data')
else
  let g:vim_cache_path = expand('$HOME/.cache/vim')
  let g:vim_data_path = expand('$HOME/.local/share/vim')
  call mkdir(g:vim_cache_path, 'p', '0750')
  call mkdir(g:vim_data_path, 'p', '0750')
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    " Create dirs
    let g:undo_dir = g:vim_cache_path . '/undo'
    call mkdir(g:undo_dir, 'p', '0750')
    let &undodir = g:undo_dir
    set undofile
endif

"----------------------------------------------------------->
"<< indent >>
"----------------------------------------------------------->
set autoindent
set smartindent
set cindent

"------------------------------------------->
" Bundle begin
" ------------------------------------------>
filetype off                   " required!

let g:vim_plug_path = g:vim_data_path . '/plugged'
call mkdir(g:vim_plug_path, 'p', '0750')
call plug#begin(g:vim_plug_path)

"--------------------------
" begin color scheme setting
"--------------------------
Plug 'jacoborus/tender.vim'
Plug 'NLKNguyen/papercolor-theme'
" Plug 'rafi/awesome-vim-colorschemes'

set laststatus=2
if (has('termguicolors'))
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

set background=dark
"----------------------------
" end color scheme setting
"---------------------------

Plug 'will133/vim-dirdiff'

" switch fcitx to en mode in normal mode.
Plug 'lilydjwg/fcitx.vim'

" git manager
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" highlight ex matching
Plug 'markonm/traces.vim'
" moving
Plug 'easymotion/vim-easymotion'
map <Leader> <Plug>(easymotion-prefix)

" file explorer
Plug 'tpope/vim-vinegar'

" ctags
" Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = g:vim_cache_path . '/tags'
" let g:gutentags_trace = 1

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'mysnips']
let g:snips_author = 'Songmin Li (Li)'
let g:snips_email = getenv('AUTHOR_EMAIL')
let g:snips_github = ''
let g:snips_company = getenv('AUTHOR_COMPANY')

" ============================
" completions
" ============================
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" file / buffer search
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

Plug 'vim-scripts/a.vim'
let g:alternateSearchPath = 'wdr:src,wdr:include,reg:|src/\([^/]\)|include/\1||,reg:|include/\([^/]\)|src/\1||'
"Plug 'LucHermitte/lh-vim-lib'
"Plug 'LucHermitte/local_vimrc'
"Plug 'LucHermitte/alternate-lite'

" dart/flutter support
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" zig support
Plug 'ziglang/zig.vim'

" markdown support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1

" android support
Plug 'udalov/kotlin-vim'
Plug 'hsanson/vim-android'
let g:gradle_path = '/usr/bin/gradle'
let g:android_sdk_path = '/opt/android-sdk'
let g:gradle_loclist_show = 0
let g:gradle_show_signs = 0

" ================================
" indent config
" ================================

" jump begin xml/tex tag
Plug 'vim-scripts/matchit.zip'

" navigate via zip
"Plug 'lbrayner/vim-rzip'

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
let g:ale_set_quickfix = 1
let g:ale_open_list = "on_save"
let g:ale_list_window_size = 5
let g:ale_completion_enabled = 0
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_completion_autoimport = 1
if &diff
    let g:ale_fix_on_save = 0
endif

" for debug
" let g:ale_command_wrapper = '~/.local/bin/ale_command_wrapper.sh'

let g:ale_c_clangformat_options = '-style=file'
let g:ale_cpp_clangformat_options = '-style=file'
let g:ale_java_javalsp_executable = '/usr/bin/java-language-server'
let g:ale_java_javalsp_prefer_root_at_cwd = 1
let g:ale_kotlin_languageserver_executable = '/usr/bin/kotlin-language-server'

nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gy <Plug>(ale_go_to_type_definition)
nmap <silent> gs :execute 'ALESymbolSearch <c-r><c-w>'<Return>
nmap <silent> gr :ALEFindReferences -relative<Return>
nmap <leader>rn  :ALERename<Return>

let g:ale_rust_analyzer_config = {
\ 'procMacro': {'enable': v:true},
\ 'cargo': {'loadOutDirsFromCheck': v:true},
\ 'diagnostics': {'disabled': ['unresolved-proc-macro']},
\}

" shfmt: pacman -S shfmt
" c/c++: pacman -S clang
" \   'c': ['clang', 'clangtidy', 'clang-format', ],
" \   'cpp': ['clang', 'clangtidy', 'clang-format'],
" eslint: pacman -S eslint
" vim-vint: pip install --user vim-vint
" prettier: pacman -S prettier
" csslint: yarn global add csslint
" tidy: pacman -S tidy
" yamllint: pacman -S yamllint
" xmllint: pacman -S libxml2 (already installed default)
" java: yay -S checkstyle
let g:ale_linters = {
\   'bash': ['shfmt'],
\   'c': ['clangtidy', 'ccls'],
\   'cpp': ['clangtidy', 'ccls'],
\   'javascript': ['eslint', 'tsserver'],
\   'vim': ['vint'],
\   'css': ['csslint'],
\   'html': ['tidy'],
\   'python': ['flake8', 'pylint', 'pylsp'],
\   'rust': ['analyzer'],
\   'tex': ['chktex'],
\   'typescript': ['eslint', 'tsserver'],
\   'xml': ['android', 'xmllint'],
\   'yaml': ['yamllint'],
\   'java': ['android', 'javalsp'],
\   'go': ['gopls'],
\   'dart': ['language_server'],
\   'zig': ['zls'],
\   'kotlin': ['android', 'languageserver'],
\}

" \   'bash': ['shfmt'],
" \   'javascript': ['eslint'],
" \   'markdown': ['prettier'],
"\   'css': ['prettier'],
"\   'scss': ['prettier'],
"\   'xml': ['xmllint'],
"\   'java': ['google_java_format'],
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'go': ['gofmt'],
\   'python': ['autopep8'],
\   'rust': ['rustfmt'],
\   'typescript': ['eslint'],
\   'json': ['prettier'],
\   'bash': ['shfmt']
\}

augroup ALE_XMLLINT_INDENTSIZE
  au BufEnter * let b:ale_xml_xmllint_indentsize = &softtabstop
augroup END

"神级插件，Emmet可以让你以一种神奇而无比爽快的感觉写HTML、CSS
Plug 'mattn/emmet-vim'

Plug 'pboettch/vim-cmake-syntax'

Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
let g:asyncrun_open = 6
noremap <silent><f5> :AsyncTask file-run<cr>
noremap <silent><f9> :AsyncTask file-build<cr>

Plug 'cespare/vim-toml'

call plug#end()            " required
" Enable file type plugin and indent
filetype plugin indent on
"-------------------------------------------<
" Bundle end
" ------------------------------------------<
" search file paths
nnoremap <leader>fp :Clap files<cr>
" search file contents
nnoremap <leader>fs :Clap grep *<cr>
" search vim buffers
nnoremap <leader>b :Clap buffers<cr>
" filter git diff
nnoremap <leader>gd :Clap git_diff_files<cr>

"----------------------------------------------------------->
"<< Latex setting.
"----------------------------------------------------------->
let g:tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'
let g:tlist_make_settings  = 'make;m:makros;t:targets'

"----------------------------------------------------------->
"<< xml folding >>
"----------------------------------------------------------->
let g:xml_syntax_folding=0

" colorscheme tender
colorscheme PaperColor
" set vim background transparent
if !&diff
  hi Normal guibg=NONE ctermbg=NONE
endif

if v:progname =~? 'vault-n\?vim'
  set noswapfile
  set nobackup
  set nowritebackup
  set viminfo=
  set clipboard=
endif
