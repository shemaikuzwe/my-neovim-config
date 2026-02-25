local function init()
    local status, neotree = pcall(require, "neo-tree")
    if not status then return end

    neotree.setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
            filtered_items = {
                visible = true, -- when true, they will be displayed even if ignored by git or dotbuttons
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false, -- only works on Windows for hidden files/folders
                hide_by_name = {
                    --"node_modules"
                },
                always_show = { -- remains visible even if other settings would hide it
                    --".gitignored",
                },
                never_show = { -- remains hidden even if visible is set to true
                    ".git",
                    --".DS_Store",
                    --"thumbs.db"
                },
            },
            follow_current_file = {
                enabled = true,
            },
            use_libuv_file_watcher = true,
        },
        window = {
            position = "left",
            width = 30,
            mappings = {
                ["<space>"] = "none",
            }
        }
    })
end

return {
    init = init,
}
