local function init()
    -- Colorizer
    local status_colorizer, colorizer = pcall(require, 'colorizer')
    if status_colorizer then colorizer.setup() end

    -- Comments
    local status_comment, comment = pcall(require, 'Comment')
    if status_comment then comment.setup() end

    -- Markdown Rendering
    local status_markdown, markdown = pcall(require, 'render-markdown')
    if status_markdown then markdown.setup() end

    -- Colorscheme
    local status_catppuccin, catppuccin = pcall(require, 'catppuccin')
    if status_catppuccin then
        catppuccin.setup({
            flavour = "macchiato", -- latte, frappe, macchiato, mocha
            transparent_background = false,
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = true,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
            },
        })
        vim.cmd.colorscheme 'catppuccin-macchiato'
    end

    -- Lualine
    local status_lualine, lualine = pcall(require, 'lualine')
    if status_lualine then
        lualine.setup({
            options = {
                theme = 'catppuccin',
                component_separators = '',
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
                lualine_b = { 'filename', 'branch' },
                lualine_c = { 'diff', 'diagnostics' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = { "fzf", "neo-tree", "lazy" },
        })
    end

    -- Notify
    local status_notify, notify = pcall(require, 'notify')
    if status_notify then
        notify.setup({
            render = "wrapped-compact",
            timeout = 2500,
        })
        vim.notify = notify
    end

    -- Noice
    local status_noice, noice = pcall(require, 'noice')
    if status_noice then
        noice.setup({
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = false,
            },
        })
    end
end

return {
    init = init,
}
