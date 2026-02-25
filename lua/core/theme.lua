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
    local status_tokyonight, tokyonight = pcall(require, 'tokyonight')
    if status_tokyonight then
        tokyonight.setup({
            style = "night",
            transparent = true,
            styles = {
                comments = { italic = false },
            },
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
                hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
                hl.TelescopePromptNormal = { bg = prompt }
                hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
                hl.TelescopePromptTitle = { bg = prompt, fg = prompt }
                hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
                hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
            end,
        })
        vim.cmd.colorscheme 'tokyonight-night'
    end

    -- Lualine
    local status_lualine, lualine = pcall(require, 'lualine')
    if status_lualine then
        lualine.setup({
            options = {
                theme = 'tokyonight',
                component_separators = '|',
                section_separators = '',
                extensions = { "fzf", "quickfix" },
            },
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
