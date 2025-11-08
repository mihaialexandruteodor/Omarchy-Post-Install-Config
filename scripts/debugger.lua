-- LEADER in LazyVim is 'SPACE'
-- Debugger configs: Java (local launch + remote attach)

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",  -- required by nvim-dap-ui
    "mfussenegger/nvim-jdtls", -- Java language server + DAP integration
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
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<Leader>c', dap.continue, {})
    vim.keymap.set('n', '<Leader>so', dap.step_over, {})
    vim.keymap.set('n', '<Leader>si', dap.step_into, {})
    vim.keymap.set('n', '<Leader>su', dap.step_out, {})

    -- ===== Java DAP Adapters =====
    -- Local Java launch using nvim-jdtls
    dap.adapters.java_launch = function(callback, config)
      -- Get debug bundles from jdtls
      local bundles = jdtls.get_debug_bundles()
      callback({
        type = 'server',
        host = '127.0.0.1',
        port = config.port or 5005,
        options = { cwd = vim.loop.cwd() },
      })
    end

    -- Remote JVM attach
    dap.adapters.java_attach = function(callback)
      callback({
        type = "server",
        host = "127.0.0.1",
        port = 8000,
      })
    end

    -- ===== Java Configurations =====
    dap.configurations.java = {
      -- Launch current Java project/main class
      {
        type = "java_launch",
        request = "launch",
        name = "Launch Current Java Project",
        mainClass = function()
          -- automatically detect main class using jdtls
          return jdtls.get_main_class()
        end,
        projectName = vim.fn.fnamemodify(vim.loop.cwd(), ":t"),
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
