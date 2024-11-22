#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

PC_REPO="${PC_REPO:-"F1bonacc1/process-compose"}"

get_latest_version() {
  local url="https://api.github.com/repos/${PC_REPO}/releases/latest"
  curl --silent --location "$url" |
    python -c "print(__import__('json').load(__import__('sys').stdin)['tag_name'])"
}

main() {
  local tmpdir latest
  tmpdir="$(mktemp --directory --tmpdir=/tmp process-compose.build.XXXXXX)"
  latest="$(get_latest_version)"

  local targz="${tmpdir}/process-compose_linux_amd64.tar.gz"
  local checksums="${tmpdir}/process-compose_checksums.txt"
  local target_dir="${tmpdir}/process-compose"
  local bin_target="$HOME/.local/bin/process-compose"
  local base_url="https://github.com/${PC_REPO}/releases/download/${latest}"

  mkdir -p "${target_dir}"
  mkdir -p "$(dirname "${bin_target}")"

  pushd "${tmpdir}"

  wget "${base_url}/process-compose_checksums.txt" &
  wget "${base_url}/process-compose_linux_amd64.tar.gz" &
  wait

  if ! grep linux_amd64 "${checksums}" | sha256sum -c; then
    echo >&2 "checksum failed"
    exit 1
  fi

  tar -xf "${targz}" -C "${target_dir}"
  install -p -m 0755 "${target_dir}/process-compose" "${bin_target}"

  popd
}

main "$@"
