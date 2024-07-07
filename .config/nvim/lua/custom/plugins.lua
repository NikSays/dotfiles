local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "nvimtools/none-ls.nvim", -- Replaced deprecated none-ls with null-ls
    ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  -- ^ from dreamsofcode-io
  -- v custom config

  -- better syntax highlighting, folding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults 
        "vim",
        "lua",

        "javascript", "typescript",
        "json", "yaml", "markdown", "markdown_inline",

        "bash",
        "comment",
        "diff", "gitignore",
        "dockerfile",


        "c",
        "go", "gomod", "gosum", "gowork", "proto"


      },
    },
  },
  -- Code action lightbulb
  { 
    'kosayoda/nvim-lightbulb',
    init = function()
       require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },
  -- Code actions in dropdown
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        }
      }
    }
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    init = function ()
      require("telescope").load_extension("ui-select")
    end
  },
  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.opt.conceallevel = 1
    end,
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/obsidian/personal",
        },
        {
          name = "work",
          path = "~/obsidian/work",
        }
      }
    }
  }
}
return plugins
