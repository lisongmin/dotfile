-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]]

return require('packer').startup(function()
  -- Load packer itself
  use { 'wbthomason/packer.nvim' }

  -- git
  use { 'tpope/vim-fugitive' }
  use { 'lewis6991/gitsigns.nvim', -- git added/removed in sidebar + inline blame
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = false
      })
    end
  }

  -- indent
  use { 'editorconfig/editorconfig-vim' } -- load indent from .editorconfig
  use { 'conormcd/matchindent.vim' } -- use tab or space according to contents.

  -- color scheme
  use 'NLKNguyen/papercolor-theme'
  use 'mjlbach/onedark.nvim'

  -- jump 
  use { 'vim-scripts/matchit.zip' } -- jump begin xml/tex tag
  use 'ggandor/lightspeed.nvim' -- quick jump by `<leader>s` or `<leader>S`
  
  -- file browser
  use 'tpope/vim-vinegar'

  -- search
  use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'kyazdani42/nvim-web-devicons' -- icons when searching

  use 'tpope/vim-eunuch' -- wrappers UNIX commands
  use 'tpope/vim-surround' -- surround characters shortcuts

  -- Debug
  use 'mfussenegger/nvim-dap'
  -- debug for golang
  use 'leoluz/nvim-dap-go'

  -- lsp plugins
  use 'neovim/nvim-lspconfig'
  use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- auto completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use {'hrsh7th/cmp-path', after = 'nvim-cmp'}

  -- snippets
  use 'L3MON4D3/LuaSnip'

  -- fixer
  use 'w0rp/ale'

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
end)
