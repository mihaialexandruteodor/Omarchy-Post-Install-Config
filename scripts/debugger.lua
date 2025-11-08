-- LEADER in LazyVim is 'SPACE'
-- Debugger configs: Java

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",  -- required by nvim-dap-ui
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- ======= DAP UI =======
    dapui.setup()

    -- Open UI when debugging starts
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    -- Close UI when debugging stops
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- ======= Keymaps =======
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<Leader>c', dap.continue, {})
    vim.keymap.set('n', '<Leader>so', dap.step_over, {})
    vim.keymap.set('n', '<Leader>si', dap.step_into, {})
    vim.keymap.set('n', '<Leader>su', dap.step_out, {})

    -- ======= Java DAP ADAPTERS =======
    -- Adapter for attaching to remote JVM
    dap.adapters.java_attach = function(callback)
      callback({
        type = "server";
        host = "127.0.0.1";
        port = 8000;
      })
    end

    -- Adapter for launching local Java program
    dap.adapters.java_launch = {
      type = "executable",
      command = "java",  -- path to your Java executable
      args = {},         -- can leave empty, args handled in configuration
    }

    -- ======= Java DAP CONFIGURATIONS =======
    dap.configurations.java = {
      -- Attach to remote JVM
      {
        type = "java_attach",
        request = "attach",
        name = "Attach to Remote JVM",
        hostName = "127.0.0.1",
        port = 8000,
      },

      -- Launch current Java file
      {
        type = "java_launch",
        request = "launch",
        name = "Launch Current Java File",
        mainClass = function()
          local filepath = vim.api.nvim_buf_get_name(0)
          local main_class = filepath:gsub("^.+/java/", ""):gsub("/", "."):gsub("%.java$", "")
          return main_class
        end,
        javaExec = "/usr/bin/java", -- adjust if needed
        projectName = vim.fn.fnamemodify(vim.loop.cwd(), ":t"),
        classPaths = {},
        modulePaths = {},
      },
    }
  end,
}
