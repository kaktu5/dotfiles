return {
  "telescope.nvim",

  cmd = { "Telescope" },

  keys = {
    { "<leader>pf", "<CMD>Telescope find_files<CR>" },
    { "<leader>pg", "<CMD>Telescope live_grep<CR>" },
  },

  -- before = function() LZN.trigger_load("telescope-zf-native.nvim") end,
  -- after = function() require("telescope").load_extension("zf-native") end,

  after = function() require("telescope") end,
}
