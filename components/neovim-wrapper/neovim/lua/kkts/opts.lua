local c = vim.cmd
local o = vim.opt

o.backup = false
o.swapfile = false
o.undofile = true

o.clipboard = "unnamedplus"
o.termguicolors = true

o.colorcolumn = "120"
o.relativenumber = true
o.signcolumn = "yes"
o.wrap = false

o.expandtab = true
o.shiftwidth = 0
o.softtabstop = -1
o.tabstop = 2

o.ignorecase = true
o.inccommand = "split"
o.smartcase = true

o.mouse = "a"
c.aunmenu({ "PopUp.-1-" })
c.aunmenu({ "PopUp.-2-" })
c.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })

o.scrolloff = 8
o.sidescrolloff = 16

o.shortmess:append({ a = true })

o.splitbelow = true
o.splitright = true

o.timeoutlen = 250
