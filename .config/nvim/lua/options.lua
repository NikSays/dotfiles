require "nvchad.options"

-- add yours here!

local o = vim.o
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 50 -- Only 50-nested code will be folded by default

o.smoothscroll=true
-- o.cursorlineopt ='both' -- to enable cursorline!
