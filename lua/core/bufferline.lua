local function init()
    local bufferline = require('bufferline')
    bufferline.setup({
        options = {
            mode = "buffers",
            numbers = "none",
            close_command = "Bdelete %d",
            right_mouse_command = "Bdelete %d",
            indicator = {
                style = 'icon',
            },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 22,
            max_prefix_length = 15,
            tab_size = 20,
            diagnostics = "nvim_lsp",
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            persist_buffer_sort = true,
            separator_style = "slant",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = true
                }
            },
        }
    })
end

return {
    init = init,
}
