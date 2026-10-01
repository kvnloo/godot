#!/usr/bin/env bash
set -u
out="${1:-godot-input-env-$(date +%Y%m%d-%H%M%S).txt}"

{
  echo "captured_at=$(date --iso-8601=seconds)"
  echo
  git rev-parse HEAD || true
  echo
  uname -a
  echo
  cat /etc/os-release
  echo
  nvidia-smi || true
  echo
  hyprctl version || true
  hyprctl monitors -j || true
} > "$out" 2>&1

echo "wrote $out"
