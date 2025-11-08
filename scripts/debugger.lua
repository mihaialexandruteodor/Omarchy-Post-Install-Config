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

    -- ===== Helper: Compile current Java file =====
    local function compile_current_file()
      local filepath = vim.api.nvim_buf_get_name(0)
      local cmd = string.format("javac %s", filepath)
      local result = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
        return false
      end
      return true
    end

    -- ===== Java DAP Adapters =====
    dap.adapters.java_launch = {
      type = 'executable',
      command = 'java',
      args = {}, -- DAP will fill mainClass later
    }

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
      -- Launch current Java file
      {
        type = "java_launch",
        request = "launch",
        name = "Launch Current Java File",
        program = function()
          local success = compile_current_file()
          if not success then
            return nil
          end
          return vim.api.nvim_buf_get_name(0)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
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
