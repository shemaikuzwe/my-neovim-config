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
                suggestion_color = "#ffffff",
                cterm = 244,
            },
            log_level = "info",
            disable_inline_completion = false,
            disable_keymaps = false,
        })
    end

    -- Opencode setup
    local status_oc, opencode = pcall(require, 'opencode')
    if status_oc then
        vim.keymap.set({ "n", "x" }, "<C-a>", function() opencode.ask("@this: ", { submit = true }) end,
            { desc = "Ask opencode" })

        vim.keymap.set({ "n", "x" }, "<C-x>", function() opencode.select() end,
            { desc = "Execute opencode action…" })

        vim.keymap.set({ "n", "t" }, "<C-.>", function() opencode.toggle() end, { desc = "Toggle opencode" })

        vim.keymap.set({ "n", "x" }, "go", function() return opencode.operator("@this ") end,
            { expr = true, desc = "Add range to opencode" })

        vim.keymap.set("n", "goo", function() return opencode.operator("@this ") .. "_" end,
            { expr = true, desc = "Add line to opencode" })
    end

    -- Increment/Decrement overrides (often used in alt4 config)
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
end

return {
    init = init,
}
