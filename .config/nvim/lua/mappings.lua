require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- dap
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dus", function ()
  local widgets = require('dap.ui.widgets');
  local sidebar = widgets.sidebar(widgets.scopes);
  sidebar.open();
end, { desc = "Open debugging sidebar" })

-- dap_go
map("n", "<leader>dgt", function()
  require('dap-go').debug_test()
end, { desc = "Debug go test" })
map( "n", "<leader>dgl", function()
  require('dap-go').debug_last()
end, { desc = "Debug last go test" })

-- gopher
map("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- lsp 
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open diagnostic window" })


