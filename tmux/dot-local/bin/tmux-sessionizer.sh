#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

TARGETS=(
  "${HOME}"
  "${HOME}/git"
  "${HOME}/git/"*/
)

tmux_switch() {
  local session="$1"
  if [[ -z "${TMUX:-}" ]]; then
    tmux attach-session -t "${session}"
  else
    tmux switch-client -t "${session}"
  fi
}

tmux_has_session() {
  local session="$1"
  tmux info &>/dev/null && tmux has-session -t "${session}" &>/dev/null
}

tmux_hydrate() {
  local session="$1"
  local cwd="$2"

  if [[ -f "${cwd}/.tmux-sessionizer" ]]; then
    tmux send-keys -t "${session}" "bash -c \"source ${cwd}/.tmux-sessionizer\"" c-M
  elif [[ -f "${HOME}/.tmux-sessionizer" ]]; then
    tmux send-keys -t "${session}" "bash -c \"source ${HOME}/.tmux-sessionizer\"" c-M
  fi
}

tmux_create_session() {
  local session="$1"
  local cwd="$2"

  if tmux_has_session "${session}"; then
    return
  fi

  tmux new-session -ds "${session}" -c "${cwd}"
  tmux_hydrate "${session}" "${cwd}"
}

list_targets() {
  (
    fd . "${TARGETS[@]}" --min-depth 1 --max-depth 1 --type directory
    zoxide query --list
  ) | sed 's:/*$::' | awk '!a[$0]++'
}

pick_target() {
  list_targets | (fzf --tmux || true)
}

main() {
  local target="${1:-}"
  local session

  if [[ -z "${target}" ]]; then
    target="$(pick_target)"
  elif [[ "${target}" == "--help" ]] || [[ "${target}" == "-h" ]]; then
    echo >&2 "tmux-sessionizer.sh"
    echo >&2 "usage: tmux-sessionizer.sh [[target] | [-h | --help]] "
    exit 1
  fi

  if [[ -z "${target}" ]]; then
    exit 0
  fi

  session="$(basename "${target}" | tr . _)"

  tmux_create_session "${session}" "${target}"
  tmux_switch "${session}"
}

main "$@"
