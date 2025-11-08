-- LEADER IN OMARCHY LAZYVIM IS 'SPACE'
-- HAS DEBUGGER CONFIGS FOR: [Java]

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",  -- required by nvim-dap-ui
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

    -- ====== Java DAP ADAPTER ======
    dap.adapters.java = function(callback)
      -- Remote JVM attach adapter (adjust port if needed)
      callback({
        type = "server";
        host = "127.0.0.1";
        port = 8000;
      })
    end

    -- ====== Java DAP CONFIGURATIONS ======
    dap.configurations.java = dap.configurations.java or {}

    -- Attach to remote JVM example
    table.insert(dap.configurations.java, {
      type = "java";
      request = "attach";
      name = "Attach to Remote JVM";
      hostName = "127.0.0.1";
      port = 8000;  -- adjust to your JPDA/Tomcat port
    })

    -- Launch current Java file (auto-detect main class at runtime)
    table.insert(dap.configurations.java, {
      type = "java";
      request = "launch";
      name = "Launch Current Java File";
      mainClass = function()
        local filepath = vim.api.nvim_buf_get_name(0)
        local main_class = filepath:gsub("^.+/java/", ""):gsub("/", "."):gsub("%.java$", "")
        return main_class
      end,
      javaExec = "/usr/bin/java",
      projectName = vim.fn.fnamemodify(vim.loop.cwd(), ":t"),
      classPaths = {},
      modulePaths = {},
    })
  end,
}
