function nvim --description "Neovim wrapper" --wraps nvim
    set -l listen_addr (_nvim_listen_addr)
    if ! contains -- --listen $argv
        set -p argv --listen $listen_addr
    end
    command nvim $argv
end
