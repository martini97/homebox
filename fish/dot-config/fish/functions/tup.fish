function tup
  # TODO(2024-11-11): @martini97: check if inside tmux session, if so create new session and then attach to it
  tmux new-session -s (basename (pwd)) -c (pwd)
end
