#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

LUA_LS_REPO="${LUA_LS_REPO:-"LuaLS/lua-language-server"}"

get_latest_version() {
  local url="https://api.github.com/repos/${LUA_LS_REPO}/releases/latest"
  curl --silent --location "$url" |
    python -c "print(__import__('json').load(__import__('sys').stdin)['tag_name'])"
}

main() {
  local latest
  latest="$(get_latest_version)"

  local install_target="$HOME/.local/share/lua-language-server"
  local bin_target="$HOME/.local/bin/lua-language-server"
  local base_url="https://github.com/${LUA_LS_REPO}/releases/download/${latest}"

  mkdir -p "${install_target}"
  mkdir -p "$(dirname "${bin_target}")"

  curl --silent --location --fail "${base_url}/lua-language-server-3.13.2-linux-x64.tar.gz" |
    tar xvz -C "${install_target}"

  ln -s "${install_target}/bin/lua-language-server" "${bin_target}"
}

main "$@"
