return {
  "blink.indent",

  event = "DeferredUIEnter",

  after = function()
    require("blink.indent").setup({
      static = {
        char = "│",
        highlights = { "BlinkIndent" },
      },
      scope = { enabled = false },
    })
  end,
}
