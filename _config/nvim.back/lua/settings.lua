-- Set default file encoding
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.fileencodings = 'utf-8,ucs-bom,gb18030,cp936'

-- Set highline on search
vim.o.hlsearch = true

-- Set default indents
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = false

-- set color scheme
vim.o.termguicolors = true
vim.cmd [[colorscheme PaperColor]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set map leader
vim.g.mapleader = ','
