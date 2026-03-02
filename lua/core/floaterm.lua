local function init()
    local options = { noremap = true, silent = true }

    -- Floating Terminal Defaults
    vim.g.floaterm_wintype = 'float'
    vim.g.floaterm_position = 'center'
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_borderchars = '─│─│╭╮╯╰'

    -- Terminal Toggle
    vim.keymap.set('n', '<leader>tt', '<CMD>FloatermToggle<CR>', options)
    vim.keymap.set('t', '<leader>tt', [[<C-\><C-n><CMD>FloatermToggle<CR>]], options)

    -- LazyGit (Large Float)
    vim.keymap.set('n', '<leader>lz', '<CMD>FloatermNew --autoclose=2 --wintype=float --position=center --width=0.9 --height=0.9 lazygit<CR>', options)
end

return {
    init = init,
}
