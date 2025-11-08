-- LEADER IN OMARCHY LAZYVIM IS 'SPACE'

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

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

    -- Keymaps
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<Leader>c', dap.continue, {})
  end,
}
