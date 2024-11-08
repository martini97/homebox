function zup
  set -l query $argv[1]
  set -l session_cwd (__zup_get_session_cwd $query)
  set -l session_name (__zup_get_session_name $session_cwd)

  _flogger -n zup -l debug "session_name: '$session_name' session_cwd: '$session_cwd'"

  __zup_create_session $session_name $session_cwd
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

function __zup_create_session -a session_name session_cwd
  _flogger -n zup -l debug "creating session if needed"

  if tmux has-session -t $session_name &> /dev/null
    _flogger -n zup -l debug "session with name '$session_name' found, skipping"
    return
  end

  _flogger -n zup -l debug "session with name '$session_name' not found, creating"
  tmux new-session -d -s $session_name -c $session_cwd
  _flogger -n zup -l debug "session with name '$session_name' created"
end

function __zup_attach_session
  set -l session_name $argv[1]

  _flogger -n zup -l debug "attaching to session '$session_name'"

  if test -z $TMUX
    _flogger -n zup -l debug "not in tmux session, attaching"
    tmux attach-session -t $session_name
  else
    _flogger -n zup -l debug "in tmux session, switching"
    tmux switch-client -t $session_name
  end
end
