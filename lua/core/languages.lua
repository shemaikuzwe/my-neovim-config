local function init()
    -- Treesitter handled in init.lua for proper loading

    -- Diagnostic configuration
    vim.diagnostic.config({
        float = { 
            border = 'rounded',
            source = 'always', -- Show which LSP sent the diagnostic
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- Diagnostic symbols
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Map filetypes for .env and yaml
    vim.filetype.add({
        extension = {
            env = 'bash',
            yaml = 'yaml',
            yml = 'yaml',
            prisma = 'prisma',
        },
        filename = {
            ['.env'] = 'bash',
        },
        pattern = {
            ['.env.*'] = 'bash',
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
                'biome',
                'prisma-language-server',
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

    -- Server list
    local servers = {
        lua_ls = {},
        biome = {
            root_dir = function(fname)
                return vim.fs.root(fname, { 'biome.json', 'biome.jsonc', 'package.json', 'tsconfig.json', '.git' })
            end,
            workspace_required = false,
            single_file_support = true,
        },
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
        prismals = {},
    }

    -- TypeScript server setup
    servers.ts_ls = { on_attach = on_attach }

    local status_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')
    if status_mason_lsp then
        mason_lsp.setup({
            ensure_installed = {
                'lua_ls',
                'biome',
                'gopls',
                'rust_analyzer',
                'ts_ls',
                'tailwindcss',
                'yamlls',
                'prismals',
            },
        })
    end

    -- Setup all servers using modern Neovim 0.11+ API if available
    for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        if not server.on_attach then
            server.on_attach = on_attach
        end
        
        if vim.lsp.config then
            vim.lsp.config(server_name, server)
            vim.lsp.enable(server_name)
        else
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
            notify_on_error = true,
            format_on_save = {
                timeout_ms = 2000,
                lsp_format = 'fallback',
            },
            formatters_by_ft = {
                lua = { 'stylua' },
                javascript = { 'biome', 'lsp', stop_after_first = true },
                typescript = { 'biome', 'lsp', stop_after_first = true },
                javascriptreact = { 'biome', 'lsp', stop_after_first = true },
                typescriptreact = { 'biome', 'lsp', stop_after_first = true },
                json = { 'biome', 'lsp', stop_after_first = true },
                jsonc = { 'biome', 'lsp', stop_after_first = true },
            },
        })
    end
end

return {
    init = init,
}
