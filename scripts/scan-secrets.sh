#!/usr/bin/env bash
#
# Lightweight secret scanner for tracked + untracked (non-ignored) files.
#
# Usage:
#   ./scripts/scan-secrets.sh

set -euo pipefail

ROOT_DIR="${1:-.}"
cd "$ROOT_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: run inside a git repository."
  exit 1
fi

echo "Scanning repository for high-risk secret patterns..."

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

# NOTE: Intentionally focuses on high-signal patterns to reduce false positives.
rg -n --hidden --follow --glob '!.git/**' \
  --glob '!node_modules/**' \
  --glob '!scripts/scan-secrets.sh' \
  --glob '!*.lock' \
  --glob '!*.svg' \
  --glob '!*.png' \
  --glob '!*.jpg' \
  --glob '!*.jpeg' \
  --glob '!*.gif' \
  --glob '!*.pdf' \
  -e 'AKIA[0-9A-Z]{16}' \
  -e 'ASIA[0-9A-Z]{16}' \
  -e 'ghp_[A-Za-z0-9]{36,}' \
  -e 'github_pat_[A-Za-z0-9_]{20,}' \
  -e 'xox[baprs]-[A-Za-z0-9-]{10,}' \
  -e 'sk-(live|test|proj)-[A-Za-z0-9]{12,}' \
  -e 'AIza[0-9A-Za-z\\-_]{35}' \
  -e 'BEGIN (RSA|OPENSSH|EC|DSA|PGP) PRIVATE KEY' \
  -e '-----BEGIN PRIVATE KEY-----' \
  -e 'SUPABASE_SERVICE_ROLE_KEY\\s*[:=]\\s*[A-Za-z0-9\\._\\-]+' \
  . > "$tmpfile" || true

if [[ -s "$tmpfile" ]]; then
  echo "POTENTIAL SECRETS FOUND:"
  cat "$tmpfile"
  echo ""
  echo "Review required before pushing."
  exit 2
fi

echo "PASS: no high-risk secret patterns found."
