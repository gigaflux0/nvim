return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    config = function()
      require("mason").setup({
        --PATH = "prepend" -- bug: this is the default but not setting it causes a problem when an lsp launches
        -- context to the bug: https://github.com/williamboman/nvim-lsp-installer/discussions/509
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = {
      "williamboman/mason.nvim"
    },
    opts = {
      auto_install = true
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "omnisharp" }
      })
    end
  },
  -- Details about the omnisharp exploding bug: https://github.com/OmniSharp/omnisharp-roslyn/issues/2574
  -- Moaid's config as a reference: https://github.com/MoaidHathot/Neovim-Moaid/blob/main/config/nvim/lua/plugins/cmp.lua
  -- Neovim for newbs youtubes as a ref: https://github.com/cpow/neovim-for-newbs/tree/main
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, --experiment    
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.omnisharp.setup({
          capabilities = capabilities,
          enable_roslyn_analysers = true,
          enable_import_completion = true,
          organize_imports_on_format = true,
          enable_decompilation_support = true,
          filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'props', 'targets' }
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
