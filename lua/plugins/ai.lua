-- ~/.config/nvim/lua/plugins/ai.lua
return {
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    opts = {
      auto_start = true,
      log_level = "warn",
      track_selection = true,
      focus_after_send = true,
      terminal = {
        provider = "native",
        split_side = "right",
        split_width_percentage = 0.35,
        auto_close = true,
      },
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = false,
      },
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>",            desc = "Claude: toggle terminal" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>",       desc = "Claude: focus terminal" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>",  mode = "v", desc = "Claude: send selection" },
      { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Claude: accept diff" },
      { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Claude: deny diff" },
      { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude: select model" },
      { "<leader>ct", "<cmd>ClaudeCodeTreeAdd<cr>",     desc = "Claude: add tree file to context" },
    },
  },
}
