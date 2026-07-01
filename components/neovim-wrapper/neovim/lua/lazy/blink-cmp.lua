return {
  "blink.cmp",

  event = "DeferredUIEnter",

  after = function()
    require("blink.cmp").setup({
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = false } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "rust" },
    })
  end,
}
