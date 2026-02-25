local function init()
    -- Treesitter
    local status_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
    if status_ts then
        ts_configs.setup({
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'go', 'rust', 'typescript', 'javascript' },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end

    -- Mason & LSP
    local status_mason, mason = pcall(require, 'mason')
    if status_mason then
        mason.setup()
        require('mason-tool-installer').setup({
            ensure_installed = {
                'lua-language-server',
                'stylua',
                'gopls',
                'rust-analyzer',
                'typescript-language-server',
                'tailwindcss-language-server',
            }
        })
    end

    local status_blink, blink = pcall(require, 'blink.cmp')
    local capabilities = status_blink and blink.get_lsp_capabilities() or {}

    local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, 'Code [A]ction')
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('grt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end

    local servers = {
        lua_ls = {},
        gopls = {},
        rust_analyzer = {},
        tailwindcss = {},
        ts_ls = {},
    }

    local status_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
    if status_mason_lsp then
        mason_lsp.setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    server.on_attach = on_attach
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        })
    end

    -- Conform (Formatting)
    local status_conform, conform = pcall(require, 'conform')
    if status_conform then
        conform.setup({
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_format = 'fallback',
            },
            formatters_by_ft = {
                lua = { 'stylua' },
            },
        })
    end

    -- TSToggle command
    vim.api.nvim_create_user_command('TSToggle', function()
        vim.g.use_tsgo = not vim.g.use_tsgo
        local current = vim.g.use_tsgo and 'tsgo (experimental)' or 'ts_ls (stable)'
        vim.notify('Switched to: ' .. current .. '\nRestarting LSP...', vim.log.levels.INFO)
        vim.cmd('edit')
    end, { desc = 'Toggle between ts_ls and tsgo LSP' })
end

return {
    init = init,
}
