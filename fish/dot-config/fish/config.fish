fish_add_path "$HOME/.local/bin"

set -gx EDITOR nvim

alias hb="homebox"

if status is-interactive && command --query zoxide
  zoxide init fish | source
end
