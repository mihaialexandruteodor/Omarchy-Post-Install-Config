-- LazyVim Java DAP Configuration (Corrected)
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-jdtls",
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

    -- ===== Java DAP Adapters =====
    -- Local launch adapter
    dap.adapters.java = {
      type = "executable",
      command = "java", -- Java runtime
      args = function(config)
        if not config.mainClass then
          vim.notify("No main class provided", vim.log.levels.ERROR)
          return {}
        end
        local classpath = vim.loop.cwd() -- default: current project
        return { "-classpath", classpath, config.mainClass }
      end,
    }

    -- Remote attach adapter
    dap.adapters.java_attach = {
      type = "server",
      host = "127.0.0.1",
      port = 8000,
    }

    -- ===== Java Configurations =====
    dap.configurations.java = {
      -- Launch current project / main class
      {
        type = "java",
        request = "launch",
        name = "Launch Current Java File",
        mainClass = function()
          local ok, main_class = pcall(jdtls.get_main_class)
          if not ok or not main_class or main_class == "" then
            vim.notify("Could not determine main class", vim.log.levels.ERROR)
            return nil
          end
          return main_class
        end,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
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
