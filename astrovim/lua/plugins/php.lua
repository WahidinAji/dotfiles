return {
  {
    "neovim/nvim-lspconfig",
    opts = {
     servers = {
        intelephense = {
          filetypes = {"php","blade","php_only"},
          settings = {
            intelephense = {
              filetypes = {"php","blade","php_only"},
              files = {
                associations = {"*.php","*.blade.php"},
                maxSize = 5000000,
              },
            },
          },
        },
        -- Add phpactor to your LSP servers
        phpactor = {

        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "php",
        "phpdoc",
      },
    },
  },
  -- For formatting
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "php-cs-fixer",
      },
    },
  },
  -- For debugging
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "php-debug-adapter",
      },
    },
  },
}
