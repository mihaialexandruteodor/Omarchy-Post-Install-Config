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

    -- ====== Java DAP CONFIG ======
    dap.configurations.java = dap.configurations.java or {}

    -- Attach to remote JVM example
    table.insert(dap.configurations.java, {
      type = "java";
      request = "attach";
      name = "Attach to Remote JVM";
      hostName = "127.0.0.1";
      port = 8000;  -- adjust to your JPDA/Tomcat port
    })

    -- Auto-detect main class from current buffer
    local function detect_main_class()
      local filepath = vim.api.nvim_buf_get_name(0)
      -- Convert path to package style: src/main/java/com/example/Main.java -> com.example.Main
      local main_class = filepath
      main_class = main_class:gsub("^.+/java/", "")       -- remove leading path up to 'java/'
      main_class = main_class:gsub("/", ".")             -- replace slashes with dots
      main_class = main_class:gsub("%.java$", "")        -- remove .java extension
      return main_class
    end

    -- Launch current Java file
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
