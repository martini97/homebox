set -gx EDITOR nvim
set -gx NVIM_LISTEN_ADDRESS (_nvim_listen_addr)

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

alias hb="homebox"

if status is-interactive
    if command --query zoxide
        zoxide init fish | source
    end

    set -l brew_bin "/home/linuxbrew/.linuxbrew/bin/brew"
    if test -x "$brew_bin"
        "$brew_bin" shellenv | source

        set -l brew_prefix ("$brew_bin" --prefix)
        set -l brew_fishd "$brew_prefix/share/fish"

        if test -d "$brew_fishd/completions"
            set -p fish_complete_path "$brew_fishd/completions"
        end

        if test -d "$brew_fishd/vendor_completions.d"
            set -p fish_complete_path "$brew_fishd/vendor_completions.d"
        end
    end

    if command --query navi
        navi widget fish | source
    end
end
