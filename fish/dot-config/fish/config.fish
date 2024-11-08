fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.lumper/bin"

set -gx EDITOR nvim
set -gx NVIM_LISTEN_ADDRESS (_nvim_listen_addr)

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
