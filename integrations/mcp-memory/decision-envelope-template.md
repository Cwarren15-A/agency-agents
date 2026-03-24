# Decision Envelope Template (Step 1)

Use this template for any high-impact action (deploys, infra changes, migrations, data deletion, auth changes, incident hotfixes).

## Required Fields

- `decision_id`: Stable ID for this decision (UUID or deterministic slug)
- `project`: Kebab-case project name
- `actor`: Agent or human making the decision
- `objective`: What outcome this step is trying to achieve
- `context_refs`: IDs/links to the memories, traces, docs, or tickets used
- `options_considered`: At least two options with tradeoffs
- `chosen_action`: The selected action
- `rejected_actions`: What was not chosen and why
- `confidence`: `high | medium | low` + one-sentence justification
- `risk_level`: `critical | high | medium | low`
- `expected_outcome`: What success should look like
- `rollback_plan`: How to safely revert if wrong

## MCP Memory Write Example

```json
{
  "project": "forge-automation",
  "category": "decision",
  "confidence": "decision",
  "source": "codex",
  "tags": ["decision-envelope", "high-impact", "deployment"],
  "summary": "Adopt blue/green deploy for API migration",
  "content": "decision_id=dec-2026-03-24-api-migration. objective=ship API migration with zero downtime. context_refs=[mem_123, mem_456, incident-778]. options_considered=[rolling deploy (fast but riskier), blue/green deploy (slower but safer)]. chosen_action=blue/green deploy. rejected_actions=rolling deploy due to rollback complexity under peak traffic. confidence=medium because traffic replay coverage is partial. risk_level=high. expected_outcome=error rate below 0.2% and p95 latency stable within 10%. rollback_plan=flip traffic to previous environment and restore previous schema compatibility."
}
```

## Rules

1. No high-impact action without a Decision Envelope memory.
2. If the decision changes, store a new memory with `supersedes`.
3. Keep Decision Envelope content self-contained (future readers should not need the original chat).
