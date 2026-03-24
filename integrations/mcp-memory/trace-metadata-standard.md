# Trace Metadata Standard (Step 2)

Use these metadata fields on every memory tied to an execution step. This gives us an event clock and replay path across agents.

## Required Metadata Fields

- `trace_id`: Shared ID for one workflow/incident/decision run
- `step_index`: Integer step number in execution order (0-based or 1-based, pick one and stay consistent)
- `event_ts_utc`: ISO-8601 timestamp in UTC for this step
- `actor`: Agent or human that produced the step

## Strongly Recommended Fields

- `parent_step`: Prior step ID or index for lineage
- `session_id`: Session/thread identifier from the client/runtime
- `tool_name`: Tool used in this step (if any)
- `decision_id`: Decision Envelope ID if this step includes a decision
- `incident_id`: Incident/ticket ID if this step is incident-related

## Example `store_memory` Metadata

```json
{
  "trace_id": "trace-retroboard-2026-03-24-001",
  "step_index": 23,
  "event_ts_utc": "2026-03-24T18:45:00Z",
  "actor": "backend-architect",
  "parent_step": "22",
  "session_id": "thread_abc123",
  "tool_name": "deploy-api",
  "decision_id": "dec-2026-03-24-api-migration",
  "incident_id": "inc-7781"
}
```

## Rule

If a memory has no `trace_id` and `step_index`, it cannot participate in decision replay.
