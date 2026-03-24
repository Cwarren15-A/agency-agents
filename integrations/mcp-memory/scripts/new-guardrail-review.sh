#!/usr/bin/env bash
#
# Scaffold a weekly guardrail review markdown file.
#
# Usage:
#   ./integrations/mcp-memory/scripts/new-guardrail-review.sh [output-dir]

set -euo pipefail

OUT_DIR="${1:-./output}"
DATE_UTC="$(date -u +%Y-%m-%d)"
OUT_FILE="${OUT_DIR}/guardrail-review-${DATE_UTC}.md"

mkdir -p "$OUT_DIR"

cat > "$OUT_FILE" <<EOF
# Weekly Guardrail Review - ${DATE_UTC}

## Source Inputs
- Incident chains reviewed:
- Outcome closures reviewed:
- Calibration report path:
- Digest reference:

## Proposed Guardrails
| guardrail_id | severity | scope | rule (if/then) | evidence_memory_ids | owner | review_date_utc | status |
|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  | proposed |

## Activation Checklist
- [ ] Each guardrail cites at least one linked incident chain
- [ ] Critical/high guardrails added to active agent instructions
- [ ] Deprecated guardrails include replacement or removal justification
- [ ] Update posted to Codex + Claude instruction surfaces
EOF

echo "Created $OUT_FILE"
