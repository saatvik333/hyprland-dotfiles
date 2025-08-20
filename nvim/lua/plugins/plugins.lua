return {{
    "LazyVim/LazyVim",
    opts = {
        -- colorscheme = function()
        -- end,
        -- colorscheme = "catppuccin",
        extras = {"lazyvim.plugins.extras.lang.typescript", "lazyvim.plugins.extras.lang.python",
                  "lazyvim.plugins.extras.lang.json", "lazyvim.plugins.extras.lang.yaml",
                  "lazyvim.plugins.extras.lang.markdown", "lazyvim.plugins.extras.lang.docker",
                  "lazyvim.plugins.extras.lang.terraform", "lazyvim.plugins.extras.lang.html",
                  "lazyvim.plugins.extras.lang.css", "lazyvim.plugins.extras.lang.tailwind",
                  "lazyvim.plugins.extras.lang.rust", "lazyvim.plugins.extras.lang.go",
                  "lazyvim.plugins.extras.lang.clangd", "lazyvim.plugins.extras.lang.prisma", 
                  "lazyvim.plugins.extras.ui.edgy", "lazyvim.plugins.extras.editor.refactoring", 
                  "lazyvim.plugins.extras.util.project"}
    }

}, {
    "williamboman/mason.nvim",
    opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, { -- Core LSP Servers
        "lua-language-server", "pyright", "ruff-lsp", "typescript-language-server", "eslint-lsp", "html-lsp", "css-lsp",
        "tailwindcss-language-server", "json-lsp", "yaml-language-server", "taplo", "marksman", "rust-analyzer",
        "gopls", "dockerfile-language-server", "terraform-ls", "prisma-language-server", "clangd", -- Formatters
        "stylua", "prettierd", "eslint_d", "shfmt", "rustfmt", "gofumpt", "goimports", "taplo", "black", "isort",
        "clang-format",

        -- Linters
        "shellcheck", "ruff", "eslint_d", "yamllint", "markdownlint", "hadolint"})
    end
}, {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
        linters_by_ft = {
            lua = {"selene"},
            python = {"ruff"},
            javascript = {"eslint_d"},
            typescript = {"eslint_d"},
            javascriptreact = {"eslint_d"},
            typescriptreact = {"eslint_d"},
            vue = {"eslint_d"},
            html = {"htmlhint"},
            css = {"stylelint"},
            scss = {"stylelint"},
            yaml = {"yamllint"},
            markdown = {"markdownlint"},
            sh = {"shellcheck"},
            dockerfile = {"hadolint"},
            terraform = {"tflint"},
            ["*"] = {"typos"}
        },
        linters = {
            typos = {
                condition = function(ctx)
                    return vim.fs.find({"typos.toml", ".typos.toml"}, {
                        path = ctx.filename,
                        upward = true
                    })[1]
                end
            }
        }
    }
}, {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = {"stylua"},
            python = {"isort", "black"},
            javascript = {{"prettierd"}},
            typescript = {{"prettierd"}},
            javascriptreact = {{"prettierd"}},
            typescriptreact = {{"prettierd"}},
            vue = {{"prettierd"}},
            html = {{"prettierd"}},
            css = {{"prettierd"}},
            scss = {{"prettierd"}},
            json = {{"prettierd"}},
            jsonc = {{"prettierd"}},
            yaml = {{"prettierd"}},
            markdown = {{"prettierd"}},
            sh = {"shfmt"},
            rust = {"rustfmt"},
            go = {"gofumpt", "goimports"},
            toml = {"taplo"},
            terraform = {"terraform_fmt"},
            cpp = {"clang-format"},
            c = {"clang-format"},
            ["*"] = {"trim_whitespace"}
        },
        formatters = {
            prettierd = {
                prepend_args = {"--tab-width", "2", "--single-quote", "true", "--trailing-comma", "es5", "--print-width", "100", "--semi", "true"}
            },
            shfmt = {
                prepend_args = {"-i", "2", "-ci", "-sr"}
            },
            rustfmt = {
                prepend_args = {"--edition", "2021"}
            },
            stylua = {
                prepend_args = {"--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120"}
            },
            black = {
                prepend_args = {"--line-length", "88", "--target-version", "py38"}
            },
            ["clang-format"] = {
                prepend_args = {"--style=Google"}
            }
        }
    }
}}
