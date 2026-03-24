# Weekly Guardrail Synthesis (Step 6)

Turn memory traces into explicit operating rules once per week.

## Inputs

1. Recent incident chains linked by `decision_id` + `incident_id`
2. Outcome closures from the same week
3. Confidence calibration report
4. Weekly digest output (`generate_digest`)

## Synthesis Process

1. Cluster repeated failures by trigger pattern.
2. Identify the earliest decision fork that predicted failure.
3. Draft a guardrail in "if/then" form.
4. Attach evidence memory IDs for traceability.
5. Add owner + review date for each guardrail.

## Guardrail Format

- `guardrail_id`: Unique ID
- `rule`: If/then statement
- `scope`: Which agents/workflows it applies to
- `evidence_memory_ids`: Source IDs backing the rule
- `severity`: `critical | high | medium | low`
- `status`: `proposed | active | deprecated`
- `owner`: Responsible person/agent
- `review_date_utc`: Next review date

## Rollout Rules

1. Critical/high guardrails should be added to agent instructions the same day.
2. Every new guardrail must cite at least one linked incident chain.
3. Deprecated guardrails require a replacement note or proof they are no longer needed.
