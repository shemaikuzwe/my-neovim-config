local function init()
    -- Treesitter handled in init.lua for proper loading

    -- Map filetypes for .env and yaml
    vim.filetype.add({
        extension = {
            env = 'dotenv',
        },
        filename = {
            ['.env'] = 'dotenv',
        },
        pattern = {
            ['.env.*'] = 'dotenv',
        },
    })

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
                'yaml-language-server',
            }
        })
    end

    local status_blink, blink = pcall(require, 'blink.cmp')
    if status_blink then
        blink.setup({
            keymap = { preset = 'enter' },
            appearance = {
                nerd_font_variant = 'mono',
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            signature = { enabled = true },
        })
    end
    local capabilities = status_blink and blink.get_lsp_capabilities() or {}

    local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, 'Code [A]ction')
        map('gd', function()
            require('telescope.builtin').lsp_definitions({ reuse_win = true })
        end, '[G]oto [D]efinition')
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
        gopls = {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        },
        rust_analyzer = {},
        tailwindcss = {},
        yamlls = {},
    }

    if vim.g.use_tsgo then
        local tsgo_config = {
            default_config = {
                cmd = { vim.fn.stdpath('data') .. '/mason/bin/tsgo', '--lsp', '--stdio' },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                root_dir = function(fname)
                    return vim.fs.root(fname, { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'package.json', 'tsconfig.json', '.git' })
                end,
            }
        }
        if vim.lsp.config then
            vim.lsp.config('tsgo', tsgo_config)
        else
            local status_lc, lspconfig = pcall(require, 'lspconfig')
            if status_lc and not lspconfig.configs.tsgo then
                lspconfig.configs.tsgo = tsgo_config
            end
        end
        servers.tsgo = {}
    else
        servers.ts_ls = {}
    end

    local status_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
    if status_mason_lsp then
        mason_lsp.setup({
            ensure_installed = {
                'lua_ls',
                'gopls',
                'rust_analyzer',
                'ts_ls',
                'tailwindcss',
                'yamlls',
            },
        })
    end

    -- Setup all servers
    for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        server.on_attach = on_attach
        
        if vim.lsp.config then
            -- Neovim 0.11+ way: use vim.lsp.config and vim.lsp.enable
            vim.lsp.config(server_name, server)
            vim.lsp.enable(server_name)
        else
            -- Legacy way for older Neovim versions
            local status_lc, lspconfig = pcall(require, 'lspconfig')
            if status_lc and lspconfig[server_name] then
                lspconfig[server_name].setup(server)
            end
        end
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
        local to_stop = vim.g.use_tsgo and 'ts_ls' or 'tsgo'

        -- Stop the previous server
        local clients = vim.lsp.get_clients({ name = to_stop })
        for _, client in ipairs(clients) do
            client.stop()
        end

        vim.notify('Switched to: ' .. current .. '\nRestarting LSP...', vim.log.levels.INFO)

        -- Schedule restart to ensure old server is gone
        vim.defer_fn(function()
            vim.cmd('edit')
        end, 100)
    end, { desc = 'Toggle between ts_ls and tsgo LSP' })
end

return {
    init = init,
}
