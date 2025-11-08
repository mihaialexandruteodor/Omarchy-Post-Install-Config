return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls = require("jdtls")

      -- Find root (where build.gradle or .git lives)
      local root_markers = { "gradlew", "build.gradle", ".git" }
      local root_dir = require("jdtls.setup").find_root(root_markers)

      -- Workspace folder
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

      local config = {
        cmd = { "jdtls" },
        root_dir = root_dir,
        settings = {
          java = {},
        },
        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)
    end,
  },
}
