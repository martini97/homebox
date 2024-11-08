function _nvim_listen_addr --description "Find nvim listen address"
    set -l nvim_id "$fish_pid"
    if test -n "$TMUX"
        set nvim_id (tmux display-message -p "#{session_name},#{window_index},#{pane_index}")
    end
    echo "/tmp/nvimsocket-$nvim_id"
end
