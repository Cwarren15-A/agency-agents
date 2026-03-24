# Outcome Closure Template (Step 3)

Create an Outcome Closure memory 24-72 hours after any high-impact decision.

## Required Fields

- `decision_id`: Decision Envelope ID being evaluated
- `closure_ts_utc`: UTC timestamp when outcome was evaluated
- `expected_outcome`: Expected result from original decision
- `actual_outcome`: What actually happened
- `incident_occurred`: `true | false`
- `rollback_required`: `true | false`
- `time_to_detect_minutes`: Minutes from change to detection
- `time_to_resolve_minutes`: Minutes from detection to resolution
- `lesson`: Concrete takeaway to improve future actions

## MCP Memory Write Example

```json
{
  "project": "forge-automation",
  "category": "lesson",
  "confidence": "fact",
  "source": "codex",
  "tags": ["outcome-closure", "learning-loop", "deployment"],
  "summary": "Blue/green deploy prevented outage but increased release time by 14 minutes",
  "content": "decision_id=dec-2026-03-24-api-migration. closure_ts_utc=2026-03-26T21:30:00Z. expected_outcome=error rate below 0.2% with stable p95. actual_outcome=error rate peaked at 0.18% and p95 remained within 7%. incident_occurred=false. rollback_required=false. time_to_detect_minutes=5. time_to_resolve_minutes=0. lesson=pre-warm read replicas before switching traffic to reduce cutover duration."
}
```

## Rules

1. Outcome Closure is mandatory for critical/high-risk decisions.
2. Store as `category=lesson` unless policy requires `context`.
3. Link the closure memory to the original decision memory.
