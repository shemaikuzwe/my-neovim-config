-- [[ Bootstrap lazy.nvim ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup({
    -- UI & Theme
    { 'folke/tokyonight.nvim', priority = 1000 },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'rcarriga/nvim-notify' },
    { 'folke/noice.nvim', dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' } },
    { 'folke/which-key.nvim', event = 'VimEnter', opts = {} },
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    { 'MeanderingProgrammer/render-markdown.nvim', opts = {} },
    { 'norcalli/nvim-colorizer.lua' },
    { 'numToStr/Comment.nvim', opts = {} },

    -- Navigation & Search
    { 'nvim-telescope/telescope.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' } },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'voldikss/vim-floaterm' },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
    },

    -- LSP & Languages
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
        },
    },
    { 'saghen/blink.cmp', version = 'v0.*' },
    { 'stevearc/conform.nvim' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- AI Tools
    { 'supermaven-inc/supermaven-nvim' },
    { 'nickjvandyke/opencode.nvim', dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' } },

    -- Git
    { 'lewis6991/gitsigns.nvim', opts = {} },

    -- Utils
    { 'NMAC427/guess-indent.nvim', opts = {} },
    { 'nvim-mini/mini.nvim' },
    { 'windwp/nvim-autopairs', opts = {} },

}, {
    ui = { icons = {} },
})

-- [[ Load Personal Config ]]
-- Wrapping in pcall to ensure Neovim starts even if configuration has errors
local status, core = pcall(require, 'core')
if status then
    core.init()
else
    vim.notify("Could not load core config: " .. tostring(core), vim.log.levels.ERROR)
end
