local function init()
    local options = { noremap = true, silent = true }

    -- Clear highlights and close floating windows
    vim.keymap.set('n', '<Esc>', function()
        vim.cmd('nohlsearch')
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative ~= "" then
                vim.api.nvim_win_close(win, false)
            end
        end
    end, { desc = 'Clear search highlights and close floating windows' })

    -- Focus floating window
    vim.keymap.set('n', '<leader>w', function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative ~= "" then
                vim.api.nvim_set_current_win(win)
                return
            end
        end
    end, { desc = 'Focus floating window' })

    -- Scroll floating window from normal mode
    local function scroll_float(key)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative ~= "" then
                local current_win = vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(win)
                vim.cmd('normal! ' .. key)
                vim.api.nvim_set_current_win(current_win)
                return true
            end
        end
        return false
    end

    vim.keymap.set('n', '<C-f>', function()
        if not scroll_float("\6") then
            vim.cmd('normal! \6')
        end
    end, { desc = 'Scroll down floating window' })

    vim.keymap.set('n', '<C-b>', function()
        if not scroll_float("\2") then
            vim.cmd('normal! \2')
        end
    end, { desc = 'Scroll up floating window' })

    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = true }) end, { desc = 'Go to previous [D]iagnostic' })
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = true }) end, { desc = 'Go to next [D]iagnostic' })
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror message' })
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

    -- Exit terminal mode
    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

    -- Window navigation (User's preferred)
    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

    -- Window navigation (AltF4 alternatives)
    vim.keymap.set('n', '<leader>h', '<CMD>wincmd h<CR>', options)
    vim.keymap.set('n', '<leader>j', '<CMD>wincmd j<CR>', options)
    vim.keymap.set('n', '<leader>k', '<CMD>wincmd k<CR>', options)
    vim.keymap.set('n', '<leader>l', '<CMD>wincmd l<CR>', options)

    -- Explorer
    vim.keymap.set('n', '\\', '<CMD>Neotree toggle<CR>', { desc = 'Toggle Explorer' })

    -- Buffer Navigation
    vim.keymap.set('n', '<S-l>', '<CMD>BufferLineCycleNext<CR>', { desc = 'Next Buffer' })
    vim.keymap.set('n', '<S-h>', '<CMD>BufferLineCyclePrev<CR>', { desc = 'Previous Buffer' })
    vim.keymap.set('n', '<leader>x', '<CMD>Bdelete<CR>', { desc = 'Close Buffer' })

    -- Commenting (Ctrl + /)
    -- Most terminals send <C-/> as <C-_>
    vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, desc = 'Toggle comment line' })
    vim.keymap.set('v', '<C-_>', 'gc', { remap = true, desc = 'Toggle comment selection' })
end

return {
    init = init,
}
