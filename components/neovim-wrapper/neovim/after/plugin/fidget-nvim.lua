local fidget = require("fidget")

fidget.setup({
  notification = {
    override_vim_notify = true,
    window = { winblend = 100 },
  },
})

vim.keymap.set("n", "<Leader>fcc", fidget.notification.clear)
vim.keymap.set("n", "<Leader>fch", fidget.notification.clear_history)
vim.keymap.set("n", "<Leader>fh", "<Cmd>Fidget history<CR>")
