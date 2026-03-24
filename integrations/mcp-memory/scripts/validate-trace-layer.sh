#!/usr/bin/env bash
#
# Validates trace-layer memory artifacts in integrations/mcp-memory.
#
# Usage:
#   ./integrations/mcp-memory/scripts/validate-trace-layer.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

require_file() {
  local f="$1"
  if [[ ! -f "$ROOT_DIR/$f" ]]; then
    echo "ERROR missing file: $f"
    exit 1
  fi
}

require_pattern() {
  local f="$1"
  local p="$2"
  if ! rg -q "$p" "$ROOT_DIR/$f"; then
    echo "ERROR missing pattern '$p' in $f"
    exit 1
  fi
}

echo "Validating trace-layer artifacts in $ROOT_DIR"

require_file "README.md"
require_file "decision-envelope-template.md"
require_file "trace-metadata-standard.md"
require_file "outcome-closure-template.md"
require_file "decision-incident-fix-linking.md"
require_file "confidence-calibration.md"
require_file "weekly-guardrail-synthesis.md"
require_file "scripts/confidence-calibration-report.py"
require_file "scripts/new-guardrail-review.sh"

# Step 1 validation (Decision Envelope)
for field in decision_id project actor objective context_refs options_considered chosen_action rejected_actions confidence risk_level expected_outcome rollback_plan; do
  require_pattern "decision-envelope-template.md" "${field}"
done

# Step 2 validation (Trace metadata + event clock)
for field in trace_id step_index event_ts_utc actor parent_step session_id tool_name decision_id incident_id; do
  require_pattern "trace-metadata-standard.md" "${field}"
done

# Step 3 validation (Outcome closure learning loop)
for field in decision_id closure_ts_utc expected_outcome actual_outcome incident_occurred rollback_required time_to_detect_minutes time_to_resolve_minutes lesson; do
  require_pattern "outcome-closure-template.md" "${field}"
done

# Step 4 validation (Decision -> Incident -> Fix linking)
require_pattern "decision-incident-fix-linking.md" "link_memories"
require_pattern "decision-incident-fix-linking.md" "decision_id"
require_pattern "decision-incident-fix-linking.md" "incident_id"
require_pattern "decision-incident-fix-linking.md" "trace_id"

# Step 5 validation (Confidence calibration)
for field in predicted_confidence_score predicted_confidence_label outcome_success overconfidence underconfidence "Brier score"; do
  require_pattern "confidence-calibration.md" "${field}"
done

# Step 6 validation (Weekly guardrail synthesis)
for field in guardrail_id rule scope evidence_memory_ids severity status owner review_date_utc; do
  require_pattern "weekly-guardrail-synthesis.md" "${field}"
done

# README should reference both standards
require_pattern "README.md" "Decision Envelope Standard"
require_pattern "README.md" "trace-metadata-standard\\.md"
require_pattern "README.md" "outcome-closure-template\\.md"
require_pattern "README.md" "decision-incident-fix-linking\\.md"
require_pattern "README.md" "confidence-calibration\\.md"
require_pattern "README.md" "weekly-guardrail-synthesis\\.md"

echo "PASS: trace-layer artifacts validated."
