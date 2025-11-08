return {
    "mfussenegger/nvim-jdtls",
    lazy = false,  -- force immediate load
    config = function()
        local jdtls = require("jdtls")
        local handlers = require("lsp.handlers")
        local mason_registry = require("mason-registry")

        local home = os.getenv("HOME")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

        -- Java executable
        local java_cmd = "java"

        -- --- Mason bundles ---
        local bundles = {}
        pcall(function()
            local java_debug = mason_registry.get_package("java-debug-adapter")
            local java_test = mason_registry.get_package("java-test")
            if java_debug then
                table.insert(
                    bundles,
                    vim.fn.glob(java_debug:get_install_path() .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
                )
            end
            if java_test then
                vim.list_extend(
                    bundles,
                    vim.split(
                        vim.fn.glob(java_test:get_install_path() .. "/extension/server/*.jar"),
                        "\n"
                    )
                )
            end
        end)

        local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

        local config = {
            cmd = {
                java_cmd,
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms512m",
                "-Xmx2048m",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-jar",
                vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                "-configuration",
                jdtls_path .. "/config_linux",
                "-data",
                workspace_dir,
            },
            root_dir = jdtls.setup.find_root({ "gradlew", "mvnw", ".metadata", ".git", "pom.xml" }),
            flags = {
                debounce_text_changes = 150,
                allow_incremental_sync = true,
            },
            capabilities = handlers.capabilities,
            init_options = { bundles = bundles },
            on_init = function(client)
                if client.config.settings then
                    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end
            end,
            on_attach = function(client, bufnr)
                handlers.on_attach(client, bufnr)

                if client.name == "jdtls" then
                    -- Which-key mappings
                    require("which-key").register({
                        ["<leader>de"] = { "<cmd>DapContinue<cr>", "[JDTLS] Debug continue" },
                        ["<leader>ro"] = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "[JDTLS] Organize imports" },
                        ["<leader>cs"] = { "<cmd>lua require'jdtls'.super_implementation()<cr>", "[JDTLS] Go to super implementation" },
                    }, { buffer = bufnr })

                    -- DAP setup
                    jdtls.setup_dap({ hotcodereplace = "auto" })
                    jdtls.setup.add_commands()

                    -- Auto-detect main class for debugging
                    require("jdtls.dap").setup_dap_main_class_configs({
                        config_overrides = {
                            vmArgs = "-Dspring.profiles.active=local",
                        },
                    })
                end
            end,
            settings = {
                java = {
                    signatureHelp = { enabled = true },
                    saveActions = { organizeImports = true },
                    completion = {
                        maxResults = 20,
                        favoriteStaticMembers = {
                            "org.hamcrest.MatcherAssert.assertThat",
                            "org.hamcrest.Matchers.*",
                            "org.hamcrest.CoreMatchers.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                            "org.mockito.Mockito.*",
                        },
                    },
                    sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
                    codeGeneration = { toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" } },
                },
            },
        }

        jdtls.start_or_attach(config)
    end,
}
