set -gx EDITOR nvim
# set -gx NVIM_LISTEN_ADDRESS (_nvim_listen_addr)

# based on https://xdgbasedirectoryspecification.com/
# and https://gist.github.com/roalcantara/107ba66dfa3b9d023ac9329e639bc58c
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_BIN_HOME "$HOME/.local/bin"
set -gx XDG_STATE_HOME "$HOME/.local/state"

fish_add_path "$XDG_BIN_HOME"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.lumper/bin"

if command --query eza
    set -g __fish_ls_command eza
else if command --query exa
    set -g __fish_ls_command exa
end

alias ll="eza -lh --group-directories-first --git --git-repos"
alias la="eza -lhA --group-directories-first --git --git-repos"

if test -f "$XDG_DATA_HOME/secrets.env"
    envsource "$XDG_DATA_HOME/secrets.env"
end

alias hb="homebox"

# after this point we should only execute if on an interactive shell
status is-interactive; or exit 0

fish_source_cmd zoxide init fish
fish_source_cmd navi widget fish

set -l brew_bin "/home/linuxbrew/.linuxbrew/bin/brew"
set -l brew_fishd "/home/linuxbrew/.linuxbrew/share/fish"
fish_source_cmd "$brew_bin" shellenv
fish_add_compl -p "$brew_fishd/completions"
fish_add_compl -p "$brew_fishd/vendor_completions.d"

fish_call_fn -f "/usr/share/fzf/shell/key-bindings.fish" fzf_key_bindings

abbr --add !! --position anywhere --function _last_history_item
