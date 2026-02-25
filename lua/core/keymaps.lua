local function init()
    local options = { noremap = true, silent = true }

    -- Clear highlights on search
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', options)

    -- Diagnostic keymaps
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
end

return {
    init = init,
}
