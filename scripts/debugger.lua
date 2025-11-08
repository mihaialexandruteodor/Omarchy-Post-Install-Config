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

    -- ===== Helper: single-file main class =====
    local function get_single_file_main_class()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then return nil end

      local filename = vim.fn.fnamemodify(bufname, ":p")
      local src_index = filename:find("/src/")
      local class_path = filename
      if src_index then
        class_path = filename:sub(src_index + 5)
      else
        class_path = vim.fn.fnamemodify(filename, ":.")
      end
      class_path = class_path:gsub("%.java$", "")
      class_path = class_path:gsub("/", ".")
      return class_path
    end

    -- ===== Use nvim-jdtls built-in DAP setup =====
    jdtls.setup_dap({ hotcodereplace = "auto" })

    -- ===== Java Configurations =====
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Launch Project / Main Class",
        mainClass = function()
          local ok, main_class = pcall(jdtls.get_main_class)
          if ok and main_class and main_class ~= "" then
            return main_class
          else
            return get_single_file_main_class()
          end
        end,
        cwd = vim.loop.cwd(),
        console = "integratedTerminal",
      },
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
