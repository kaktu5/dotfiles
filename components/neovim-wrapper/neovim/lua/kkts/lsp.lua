vim.lsp.config("*", {
  root_markers = { ".jj", "flake.nix" },
})

vim.lsp.enable({
  "lua_ls",
  "nixd",
  "rust_analyzer",
  "tinymist",
  "tombi",
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

vim.keymap.set("n", "gK", function()
  local vl = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = vl })
end)
