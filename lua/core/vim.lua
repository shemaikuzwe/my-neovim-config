local function set_vim_g()
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    vim.g.have_nerd_font = true
    -- TypeScript LSP toggle: false = ts_ls (default), true = tsgo (experimental)
    vim.g.use_tsgo = true

    -- Disable netrw (built-in file explorer)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

local function set_vim_o()
    local settings = {
        number = true,
        mouse = 'a',
        showmode = false,
        breakindent = true,
        undofile = true,
        ignorecase = true,
        smartcase = true,
        signcolumn = 'yes',
        updatetime = 250,
        timeoutlen = 300,
        splitright = true,
        splitbelow = true,
        cursorline = true,
        scrolloff = 10,
        confirm = true,
        inccommand = 'split',
        termguicolors = true,
        expandtab = true,
        shiftwidth = 4,
        tabstop = 4,
    }

    for k, v in pairs(settings) do
        vim.o[k] = v
    end

    -- Sync clipboard between OS and Neovim
    vim.schedule(function()
        vim.o.clipboard = 'unnamedplus'
    end)
end

local function set_vim_opt()
    vim.opt.laststatus = 3
    vim.opt.list = true
    vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '↴' }
    vim.opt.splitkeep = "screen"
end

local function set_autocmds()
    -- Auto-save on inactivity
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        pattern = '*',
        callback = function()
            if vim.bo.modified then
                vim.cmd('silent! update')
            end
        end,
        desc = 'Auto-save on inactivity',
    })

    -- Highlight when yanking
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function()
            vim.hl.on_yank()
        end,
    })
end

local function init()
    set_vim_g()
    set_vim_o()
    set_vim_opt()
    set_autocmds()
end

return {
    init = init,
}
