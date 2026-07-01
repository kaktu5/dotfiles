local formatters_by_ft = {
  lua = { "stylua" },
  nix = { "alejandra", "nixfmt", stop_after_first = true },
  rust = { "rustfmt" },
  toml = { "tombi" },
  typ = { "typstyle" },
}

return {
  "conform.nvim",

  cmd = { "ConformInfo" },

  ft = vim.tbl_keys(formatters_by_ft),

  keys = {
    { "<Leader>lf", function() require("conform").format({ async = true }) end },
  },

  after = function()
    require("conform").setup({
      formatters_by_ft = formatters_by_ft,
    })
  end,
}
