-- Language policy -----------------------------------------------------------
--
-- This is the only section that should need routine changes. LSP names come
-- from nvim-lspconfig. Formatter names come from conform.nvim. A formatter's
-- Mason package and executable default to its Conform name unless specified.
-- Astro lsp fix: npm install --prefix "$HOME/.local/share/nvim/mason/packages/astro-language-server" --save-exact typescript@6.0.3

local policy = {
  prompt_timeout_ms = 5000,
  format_timeout_ms = 1000,

  filetype_detection = {
    extension = {
      bean = "beancount",
      beancount = "beancount",
    },
  },

  languages = {
    astro = {
      label = "Astro",
      lsp = { "astro" },
      formatters = { "prettierd" },
    },
    lua = {
      label = "Lua",
      lsp = { "lua_ls" },
      formatters = { "stylua" },
    },
    python = {
      label = "Python",
      lsp = { "pyright", "ruff" },
      formatters = {
        { name = "ruff_format", package = "ruff", command = "ruff" },
      },
    },
    c = {
      label = "C",
      lsp = { "clangd" },
      formatters = {
        { name = "clang_format", package = "clang-format", command = "clang-format" },
      },
    },
    cpp = {
      label = "C++",
      lsp = { "clangd" },
      formatters = {
        { name = "clang_format", package = "clang-format", command = "clang-format" },
      },
    },
    java = {
      label = "Java",
      lsp = { "jdtls" },
      formatters = { "google-java-format" },
    },
    html = {
      label = "HTML",
      lsp = { "html" },
      formatters = { "prettierd" },
    },
    css = {
      label = "CSS",
      lsp = { "cssls" },
      formatters = { "prettierd" },
    },
    javascript = {
      label = "JavaScript",
      lsp = { "ts_ls" },
      formatters = { "prettierd" },
    },
    javascriptreact = {
      label = "JavaScript React",
      lsp = { "ts_ls" },
      formatters = { "prettierd" },
    },
    typescript = {
      label = "TypeScript",
      lsp = { "ts_ls" },
      formatters = { "prettierd" },
    },
    typescriptreact = {
      label = "TypeScript React",
      lsp = { "ts_ls" },
      formatters = { "prettierd" },
    },
    sql = {
      label = "SQL",
      lsp = { "sqls" },
      formatters = {
        { name = "sql_formatter", package = "sql-formatter", command = "sql-formatter" },
      },
    },
    go = {
      label = "Go",
      lsp = { "gopls" },
      formatters = { "goimports", "gofumpt" },
    },
    typst = {
      label = "Typst",
      lsp = { "tinymist" },
      formatters = { "typstyle" },
    },
    beancount = {
      label = "Beancount",
      lsp = { "beancount" },
    },
    yaml = {
      label = "YAML",
      formatters = { "prettierd" },
    },
    json = {
      label = "JSON",
      formatters = { "prettierd" },
    },
    jsonc = {
      label = "JSON with comments",
      formatters = { "prettierd" },
    },
  },

  lsp_overrides = {
    lua_ls = {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
        },
      },
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    ruff = {
      init_options = {
        settings = {
          lint = { select = { "E", "F", "I" } },
        },
      },
    },
    tinymist = {
      offset_encoding = "utf-8",
    },
    beancount = {
      init_options = {
        journal_file = vim.fn.expand("~/dev/beans/ledger.beancount"),
      },
    },
  },

  formatter_overrides = {
    clang_format = {
      prepend_args = { "-style={BasedOnStyle: Google, IndentWidth: 4}" },
    },
  },
}

-- Implementation ------------------------------------------------------------
-- Everything below is derived from the policy above.

local function formatter_name(formatter)
  return type(formatter) == "string" and formatter or formatter.name
end

local function formatter_package(formatter)
  return type(formatter) == "string" and formatter or formatter.package or formatter.name
end

local function formatter_command(formatter)
  return type(formatter) == "string" and formatter or formatter.command or formatter.package or formatter.name
end

local function conform_formatters_by_ft()
  local result = {}
  for filetype, language in pairs(policy.languages) do
    if language.formatters then
      result[filetype] = vim.tbl_map(formatter_name, language.formatters)
    end
  end
  return result
end

local function policy_lsp_servers()
  local result = {}
  local seen = {}
  for _, language in pairs(policy.languages) do
    for _, server in ipairs(language.lsp or {}) do
      if not seen[server] then
        result[#result + 1] = server
        seen[server] = true
      end
    end
  end
  table.sort(result)
  return result
end

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "folke/snacks.nvim",
      "saghen/blink.cmp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({ automatic_enable = policy_lsp_servers() })

      vim.filetype.add(policy.filetype_detection)

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      for server, config in pairs(policy.lsp_overrides) do
        vim.lsp.config(server, config)
      end

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
        virtual_text = false,
      })

      local attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
      local highlight_group = vim.api.nvim_create_augroup("lsp-document-highlight", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = attach_group,
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local function map(keys, action, description, mode)
            vim.keymap.set(mode or "n", keys, action, {
              buffer = event.buf,
              desc = "LSP: " .. description,
            })
          end

          map("grD", vim.lsp.buf.declaration, "Declaration")
          map("grr", Snacks.picker.lsp_references, "References")
          map("gri", Snacks.picker.lsp_implementations, "Implementations")
          map("grd", Snacks.picker.lsp_definitions, "Definitions")
          map("grt", Snacks.picker.lsp_type_definitions, "Type Definitions")
          map("gO", Snacks.picker.lsp_symbols, "Document Symbols")
          map("gW", Snacks.picker.lsp_workspace_symbols, "Workspace Symbols")

          if
            client:supports_method("textDocument/documentHighlight", event.buf)
            and not vim.b[event.buf].lsp_document_highlight
          then
            vim.b[event.buf].lsp_document_highlight = true
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client:supports_method("textDocument/inlayHint", event.buf) then
            map("<leader>th", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle Inlay Hints")
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = attach_group,
        callback = function(event)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(event.buf) then
              return
            end
            local has_highlight_client = vim.iter(vim.lsp.get_clients({ bufnr = event.buf })):any(function(client)
              return client:supports_method("textDocument/documentHighlight", event.buf)
            end)
            if not has_highlight_client then
              vim.lsp.util.buf_clear_references(event.buf)
              vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = event.buf })
              vim.b[event.buf].lsp_document_highlight = false
            end
          end)
        end,
      })

      local registry = require("mason-registry")
      local registry_ready = false
      local registry_refreshing = false
      local registry_waiters = {}
      local pending_packages = {}
      local dismissed_packages = {}
      local warned_servers = {}

      local function with_registry(callback)
        if registry_ready then
          callback()
          return
        end

        table.insert(registry_waiters, callback)
        if registry_refreshing then
          return
        end
        registry_refreshing = true

        registry.refresh(function(success)
          vim.schedule(function()
            registry_ready = true
            registry_refreshing = false
            if not success then
              Snacks.notify.warn("Mason could not refresh its package registry", { title = "Language tools" })
            end
            local waiters = registry_waiters
            registry_waiters = {}
            for _, waiter in ipairs(waiters) do
              waiter()
            end
          end)
        end)
      end

      local function command_is_executable(command)
        return type(command) == "string" and vim.fn.executable(command) == 1
      end

      local function lsp_command_is_available(server, package_name)
        local ok, config = pcall(function()
          return vim.lsp.config[server]
        end)
        if not ok or not config then
          return false
        end
        if type(config.cmd) == "function" then
          return command_is_executable(package_name)
        end
        return type(config.cmd) == "table" and command_is_executable(config.cmd[1])
      end

      local function package_is_installing(name)
        local ok, package = pcall(registry.get_package, name)
        return ok and package:is_installing()
      end

      local function package_is_busy(name)
        return pending_packages[name] or dismissed_packages[name] or package_is_installing(name)
      end

      local function add_missing(missing, package_name)
        if not registry.is_installed(package_name) and not package_is_busy(package_name) then
          missing[package_name] = true
        end
      end

      local function install_packages(filetype, language, package_names)
        local remaining = #package_names
        local failures = {}
        local notification_id = "language-tools:" .. filetype

        Snacks.notify.info("Installing " .. table.concat(package_names, ", "), {
          id = notification_id,
          title = language.label .. " tools",
          timeout = false,
        })

        local function complete(package_name, success, err)
          pending_packages[package_name] = nil
          if not success then
            failures[#failures + 1] = package_name .. (err and (": " .. tostring(err)) or "")
          end
          remaining = remaining - 1
          if remaining > 0 then
            return
          end
          if #failures > 0 then
            Snacks.notify.error(table.concat(failures, "\n"), {
              id = notification_id,
              title = "Failed to install " .. language.label .. " tools",
              timeout = 5000,
            })
          else
            Snacks.notify.info("Installed " .. table.concat(package_names, ", "), {
              id = notification_id,
              title = language.label .. " tools",
            })
          end
        end

        for _, package_name in ipairs(package_names) do
          if registry.is_installed(package_name) then
            complete(package_name, true)
          else
            local ok, package = pcall(registry.get_package, package_name)
            if not ok then
              complete(package_name, false, package)
            elseif package:is_installing() then
              complete(package_name, true)
            else
              local started, err = pcall(function()
                package:install({}, function(success, install_error)
                  vim.schedule(function()
                    complete(package_name, success, install_error)
                  end)
                end)
              end)
              if not started then
                complete(package_name, false, err)
              end
            end
          end
        end
      end

      local function prompt_to_install(filetype, language, package_names)
        for _, package_name in ipairs(package_names) do
          pending_packages[package_name] = true
        end

        local package_summary = table.concat(package_names, ", ")
        local picker = Snacks.picker.select({
          { label = "Yes", install = true },
          { label = "No", install = false },
        }, {
          prompt = ("Install missing %s tools? %s"):format(language.label, package_summary),
          format_item = function(item)
            return item.label
          end,
          snacks = {
            focus = "list",
            win = {
              list = {
                keys = {
                  ["<LeftMouse>"] = "confirm",
                },
              },
            },
          },
        }, function(choice)
          if choice and choice.install then
            install_packages(filetype, language, package_names)
            return
          end
          for _, package_name in ipairs(package_names) do
            pending_packages[package_name] = nil
            dismissed_packages[package_name] = true
          end
        end)

        vim.defer_fn(function()
          if picker and not picker.closed then
            picker:close()
          end
        end, policy.prompt_timeout_ms)
      end

      local function check_buffer(bufnr)
        if #vim.api.nvim_list_uis() == 0 or not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local filetype = vim.bo[bufnr].filetype
        local language = policy.languages[filetype]
        if not language then
          return
        end

        with_registry(function()
          if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= filetype then
            return
          end

          local mappings = require("mason-lspconfig").get_mappings().lspconfig_to_package
          local missing = {}

          for _, server in ipairs(language.lsp or {}) do
            local package_name = mappings[server]
            if
              lsp_command_is_available(server, package_name)
              or (package_name and registry.is_installed(package_name))
            then
              if not vim.lsp.is_enabled(server) then
                vim.lsp.enable(server)
              end
            elseif package_name then
              add_missing(missing, package_name)
            elseif not warned_servers[server] then
              warned_servers[server] = true
              Snacks.notify.warn("No Mason package is mapped to LSP config " .. server, {
                title = "Language tools",
              })
            end
          end

          for _, formatter in ipairs(language.formatters or {}) do
            local package_name = formatter_package(formatter)
            if not command_is_executable(formatter_command(formatter)) then
              add_missing(missing, package_name)
            end
          end

          local package_names = vim.tbl_keys(missing)
          table.sort(package_names)
          if #package_names > 0 then
            prompt_to_install(filetype, language, package_names)
          end
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("language-tools", { clear = true }),
        callback = function(event)
          check_buffer(event.buf)
        end,
      })

      if vim.bo.filetype ~= "" then
        vim.schedule(function()
          check_buffer(0)
        end)
      end
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format",
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = conform_formatters_by_ft(),
      formatters = policy.formatter_overrides,
      format_on_save = {
        timeout_ms = policy.format_timeout_ms,
        lsp_format = "fallback",
      },
    },
  },

  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = { "folke/lazydev.nvim" },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = false,
        ["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      snippets = { preset = "default" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
}
