local linters_by_ft = {
  lua = { "selene" },
  rust = { "clippy" },
  toml = { "tombi" },
}

return {
  "nvim-lint",

  ft = vim.tbl_keys(linters_by_ft),

  after = function()
    local lint = require("lint")

    lint.linters_by_ft = linters_by_ft
    lint.try_lint()

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      callback = function() lint.try_lint() end,
    })
  end,
}
