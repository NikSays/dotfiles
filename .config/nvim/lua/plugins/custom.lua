return {
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

