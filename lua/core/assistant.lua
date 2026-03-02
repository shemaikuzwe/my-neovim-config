local function init()
    -- Supermaven setup
    local status_sm, sm = pcall(require, "supermaven-nvim")
    if status_sm then
        sm.setup({
            keymaps = {
                accept_suggestion = "<Tab>",
                clear_suggestion = "<C-]>",
                accept_word = "<C-j>",
            },
            ignore_filetypes = { cpp = true },
            color = {
                suggestion_color = "#808080",
                cterm = 244,
            },
            log_level = "info",
            disable_inline_completion = false,
            disable_keymaps = false,
        })
    end

    -- Increment/Decrement overrides (often used in alt4 config)
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
end

return {
    init = init,
}
