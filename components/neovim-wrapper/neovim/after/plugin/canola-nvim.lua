vim.keymap.set("n", "<Leader>pv", function() require("canola").open() end)

vim.g.canola = {
  -- https://github.com/barrettruth/canola.nvim/issues/342
  columns = {
    "permissions",
    "size",
    "mtime",
    { name = "icon", add_padding = false },
  },

  confirm = "delete",

  watch = true,

  keymaps = {},

  hidden = { enabled = false },

  border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
}
