if vim.b.did_my_ts_indent then
  return
end

vim.b.did_my_ts_indent = 1

-- /usr/share/nvim/runtime/indent/typescript.vim overrides the formatexpr
-- setting, so we have to override it here as well
require("core.formatter").register()
