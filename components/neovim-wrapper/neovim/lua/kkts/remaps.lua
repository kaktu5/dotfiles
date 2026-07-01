local set = vim.keymap.set

vim.g.mapleader = " "

set("n", "Q", "<NOP>")
set("n", "J", "mzJ`z")
set("n", "\\", ":noh<CR>")

set("x", "J", ":m '>+1<CR>gv=gv")
set("x", "K", ":m '<-2<CR>gv=gv")

set("v", "<Leader>p", '"_dP')
