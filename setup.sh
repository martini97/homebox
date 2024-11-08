#!/usr/bin/env bash

set -euo pipefail

main() {
  sudo dnf update --refresh
  sudo dnf install ansible

  sudo dnf install \
    kitty \
    kitty-terminfo \
    kitty-doc \
    jetbrains-mono-fonts-all

  sudo dnf install zoxide
}

main
