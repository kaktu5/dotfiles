return {
  "nvim-colorizer.lua",

  event = { "BufReadPre", "BufNewFile" },

  after = function() require("colorizer").setup({ "*" }) end,
}
