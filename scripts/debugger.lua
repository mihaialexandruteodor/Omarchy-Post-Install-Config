-- LazyVim Java DAP Configuration
-- Leader is <Space>

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",  -- required by dap-ui
    "mfussenegger/nvim-jdtls", -- Java LSP + DAP integration
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local jdtls = require("jdtls")

    -- ===== DAP UI =====
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- ===== Keymaps =====
    vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>c", dap.continue, {})
    vim.keymap.set("n", "<Leader>so", dap.step_over, {})
    vim.keymap.set("n", "<Leader>si", dap.step_into, {})
    vim.keymap.set("n", "<Leader>su", dap.step_out, {})
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
    vim.keymap.set("n", "<Leader>dl", dap.run_last, {})

    -- ===== Java DAP Adapters =====
    dap.adapters.java = function(callback)
      local bundles = jdtls.get_debug_bundles()
      callback({
        type = "server",
        host = "127.0.0.1",
        port = 5005,  -- JDWP port used by jdtls debug
        options = { cwd = vim.loop.cwd() },
      })
    end

    dap.adapters.java_attach = {
      type = "server",
      host = "127.0.0.1",
      port = 8000,  -- adjust to your remote JDWP port
    }

    -- ===== Java Configurations =====
    dap.configurations.java = {
      -- Launch current Java project / main class
      {
        type = "java",
        request = "launch",
        name = "Launch Current Java Project",
        mainClass = function()
          local ok, main_class = pcall(jdtls.get_main_class)
          if not ok or not main_class or main_class == "" then
            vim.notify("Could not determine main class. Make sure your project has a main method.", vim.log.levels.ERROR)
            return nil
          end
          return main_class
        end,
        projectName = vim.fn.fnamemodify(vim.loop.cwd(), ":t"),
        classPaths = {},   -- auto-filled by jdtls
        modulePaths = {},  -- auto-filled by jdtls
        console = "integratedTerminal",  -- VS Code-like behavior
      },

      -- Attach to remote JVM
      {
        type = "java_attach",
        request = "attach",
        name = "Attach to Remote JVM",
        hostName = "127.0.0.1",
        port = 8000,
      },
    }
  end,
}
