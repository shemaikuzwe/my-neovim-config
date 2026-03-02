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

-- Add Mason bin to PATH
vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.stdpath('data') .. '/mason/bin'

-- [[ Configure plugins ]]
vim.api.nvim_create_autocmd("FileType", {
    pattern = "prisma",
    callback = function()
        vim.treesitter.start()
    end,
})

require('lazy').setup({
    -- UI & Theme
    { 'rose-pine/neovim', name = 'rose-pine' },
    { 'folke/tokyonight.nvim', priority = 1000 },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rebelot/kanagawa.nvim", priority = 1000 },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
    { 'moll/vim-bbye' },
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
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
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
    { 
        'nvim-treesitter/nvim-treesitter', 
        lazy = false,
        priority = 1000,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup({
                ensure_installed = { 
                    'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 
                    'query', 'vim', 'vimdoc', 'go', 'rust', 'typescript', 'javascript', 
                    'yaml', 'json', 'dockerfile', 'prisma'
                },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

    -- AI Tools
    { 'supermaven-inc/supermaven-nvim' },

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
