function zup
  set -l query $argv[1]
  set -l session_cwd (__zup_get_session_cwd $query)
  set -l session_name (__zup_get_session_name $session_cwd)

  __zup_create_session $session_name $session_path
  __zup_attach_session $session_name
end

function __zup_get_session_cwd
  set -l query $argv[1]
  if test -z $query
    zoxide query --interactive
  else
    zoxide query $query
  end
end

function __zup_get_session_name
  set -l cwd $argv[1]
  basename $cwd
end

function __zup_create_session
  set -l session_name $argv[1]
  set -l session_path $argv[2]

  if ! tmux has-session -t $session_name
    tmux new-session -d -s $session_name -c $session_cwd
  end
end

function __zup_attach_session
  set -l session_name $argv[1]

  if test -z $TMUX
    tmux attach-session -t $session_name
  else
    tmux switch-client -t $session_name
  end
end
