if vim.env.TMUX then
  vim.g.fzf_select_tmux = "70%,70%"
end

vim.g.fzf_select_window = { width = 0.9, height = 0.6 }

require("core.fzf").register()
