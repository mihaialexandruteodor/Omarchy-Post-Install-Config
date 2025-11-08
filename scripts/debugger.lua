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
    vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
    vim.keymap.set("n", "<Leader>dl", dap.run_last, {})

    -- ===== Java DAP Adapters =====
    dap.adapters.java = {
      type = "executable",
      command = "java",
      args = function(config)
        if not config.mainClass then
          vim.notify("No main class provided", vim.log.levels.ERROR)
          return {}
        end
        local cp = vim.loop.cwd()
        return { "-classpath", cp, config.mainClass }
      end,
    }

    dap.adapters.java_attach = {
      type = "server",
      host = "127.0.0.1",
      port = 8000,
    }

    -- ===== Java Configurations =====
    dap.configurations.java = {
      -- Launch project / main class (Maven/Gradle)
      {
        type = "java",
        request = "launch",
        name = "Launch Project / Main Class",
        mainClass = function()
          local ok, main_class = pcall(jdtls.get_main_class)
          if ok and main_class and main_class ~= "" then
            return main_class
          else
            -- Fallback to automatic single-file detection
            local class = get_single_file_main_class()
            if class then
              return class
            else
              vim.notify("Could not determine main class", vim.log.levels.ERROR)
              return nil
            end
          end
        end,
        cwd = vim.loop.cwd(),
        console = "integratedTerminal",
      },

      -- Remote attach
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
