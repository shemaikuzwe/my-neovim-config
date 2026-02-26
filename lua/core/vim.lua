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
        relativenumber = true,
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
    -- Map filetypes explicitly
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.yaml', '*.yml' },
        callback = function()
            vim.bo.filetype = 'yaml'
        end,
    })

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '.env', '.env.*' },
        callback = function()
            vim.bo.filetype = 'dotenv'
        end,
    })

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

    -- Tmux status bar toggle
    if vim.env.TMUX ~= nil then
        local tmux_group = vim.api.nvim_create_augroup('tmux-status-toggle', { clear = true })

        local function set_tmux_status(state)
            vim.system({ 'tmux', 'set-option', '-g', 'status', state })
        end

        vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'VimResume' }, {
            group = tmux_group,
            callback = function() set_tmux_status('off') end,
        })

        vim.api.nvim_create_autocmd({ 'VimLeavePre', 'FocusLost', 'VimSuspend' }, {
            group = tmux_group,
            callback = function() set_tmux_status('on') end,
        })

        -- Manual toggle
        vim.keymap.set('n', '<leader>ts', function()
            vim.system({ 'tmux', 'show-options', '-gv', 'status' }, { text = true }, function(obj)
                local current = obj.stdout:gsub("%s+", "")
                local next_state = (current == 'on') and 'off' or 'on'
                set_tmux_status(next_state)
            end)
        end, { desc = 'Toggle Tmux Status Bar' })
    end
end

local function init()
    set_vim_g()
    set_vim_o()
    set_vim_opt()
    set_autocmds()

    -- Ensure syntax highlighting is active
    vim.cmd('syntax on')
    vim.cmd('filetype plugin indent on')
end

return {
    init = init,
}
