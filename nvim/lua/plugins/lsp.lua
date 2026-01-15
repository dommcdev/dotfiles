-- Modern LSP configuration based on kickstart.nvim
-- Uses snacks.picker instead of Telescope, blink.cmp for completion

return {
    -- Lazydev: Lua LSP enhancements for Neovim config
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Main LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Mason must be loaded before dependents
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Completion capabilities
            "saghen/blink.cmp",
        },
        config = function()
            -- LspAttach: runs when an LSP attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Standard LSP keymaps (gr* prefix as per Neovim 0.11+ conventions)
                    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
                    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- LSP navigation via snacks.picker
                    map("grr", function()
                        Snacks.picker.lsp_references()
                    end, "[G]oto [R]eferences")
                    map("gri", function()
                        Snacks.picker.lsp_implementations()
                    end, "[G]oto [I]mplementation")
                    map("grd", function()
                        Snacks.picker.lsp_definitions()
                    end, "[G]oto [D]efinition")
                    map("grt", function()
                        Snacks.picker.lsp_type_definitions()
                    end, "[G]oto [T]ype Definition")
                    map("gO", function()
                        Snacks.picker.lsp_symbols()
                    end, "Document Symbols")
                    map("gW", function()
                        Snacks.picker.lsp_workspace_symbols()
                    end, "Workspace Symbols")

                    -- Additional useful mappings
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("<leader>d", vim.diagnostic.open_float, "Show Diagnostics")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if not client then
                        return
                    end

                    -- Document highlight on cursor hold
                    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- Inlay hints toggle
                    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            -- Diagnostic configuration
            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                },
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                },
            })

            -- Auto-show diagnostic float on CursorHold
            vim.api.nvim_create_autocmd("CursorHold", {
                group = vim.api.nvim_create_augroup("diagnostic-float", { clear = true }),
                callback = function()
                    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
                end,
            })

            -- Get capabilities from blink.cmp
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- LSP server configurations
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = { callSnippet = "Replace" },
                        },
                    },
                },
                clangd = {},
                ruff = {},
            }

            -- Tools to install via Mason
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "clang-format",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- Autoformat with conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[C]ode [F]ormat",
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable format_on_save for certain filetypes
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end,
            formatters_by_ft = {
                python = { "ruff_format" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                lua = { "stylua" },
            },
            formatters = {
                clang_format = {
                    prepend_args = { "-style={BasedOnStyle: Google, IndentWidth: 4}" },
                },
            },
        },
    },

    -- Autocompletion with blink.cmp
    {
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "1.*",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "folke/lazydev.nvim",
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
            },
            sources = {
                default = { "lsp", "path", "snippets", "lazydev" },
                providers = {
                    lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
                },
            },
            snippets = { preset = "luasnip" },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
        },
    },

    -- Trouble for diagnostics UI
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {},
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        },
    },
}
