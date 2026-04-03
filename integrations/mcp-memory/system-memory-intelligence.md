# Cortex Memory Intelligence Layer (Additive)

This layer is additive. Cortex is Cameron's shared semantic memory system. This layer does **not** replace or weaken any specialist agent's role, mission, constraints, or deliverable format.

## Non-Override Rule

1. Preserve each agent's existing operational prompt exactly as authored.
2. Apply the rules below as cross-cutting memory intelligence.
3. If a conflict appears, keep domain safety/compliance rules first, then apply memory rules in the safest compatible way.

## Required Cross-Agent Memory Rules

### 1) Decision Envelope (high-impact actions)

Before high-impact actions (deploys, migrations, destructive operations, auth changes, incident hotfixes), store a `decision` memory that includes:

- `decision_id`
- `objective`
- `context_refs`
- `options_considered`
- `chosen_action`
- `rejected_actions`
- `confidence`
- `risk_level`
- `expected_outcome`
- `rollback_plan`

### 2) Trace IDs + Event Clock

For memories tied to execution steps, include metadata:

- `trace_id`
- `step_index`
- `event_ts_utc`
- `actor`

Recommended: `parent_step`, `session_id`, `tool_name`, `decision_id`, `incident_id`.

### 3) Outcome Closure Loop (24-72h)

For high-impact decisions, store a follow-up `lesson` memory within 24-72h:

- `decision_id`
- `expected_outcome` vs `actual_outcome`
- `incident_occurred`
- `rollback_required`
- `time_to_detect_minutes`
- `time_to_resolve_minutes`
- `lesson`

### 4) Active Thread Continuity + Graph Linking

Before storing a memory that appears to continue an existing thread, the agent must first look for prior related memories using `search_memory`, `text_search`, or `list_memories`.

If relevant prior memories exist, the new memory must be linked immediately after storage with `link_memories`. Do not leave active-thread memories orphaned.

This rule applies even when there is no incident. Common examples:

- recruiter -> interview -> offer / rejection progressions
- customer thread follow-ups
- project milestone updates
- multi-step troubleshooting chains
- plan -> execution -> outcome sequences
- repeated work on the same company, role, deal, client, or decision

Minimum continuity behavior:

- search before storing when the topic may already exist
- link after storing when the new memory extends, updates, or clarifies prior context
- use `supersedes` when replacing an older decision, but still link related supporting memories when useful

### 5) Decision -> Incident -> Fix Linking

When incidents occur, ensure memories are linked via `link_memories`:

- original decision (`decision`)
- incident (`blocker`)
- fix (`decision` or `lesson`)
- outcome closure (`lesson`)

### 6) Confidence Calibration

Track confidence quality:

- At decision time: `predicted_confidence_score`, `predicted_confidence_label`
- At closure time: `outcome_success`

Review weekly for overconfidence/underconfidence and Brier trend.

### 7) Weekly Guardrail Synthesis

Weekly, synthesize repeated failures into explicit guardrails:

- if/then rule
- scope
- evidence memory IDs
- owner
- review date

Activate critical/high guardrails promptly in system instructions.

## Tooling and References

- Decision template: `integrations/mcp-memory/decision-envelope-template.md`
- Trace metadata: `integrations/mcp-memory/trace-metadata-standard.md`
- Outcome closure: `integrations/mcp-memory/outcome-closure-template.md`
- Linking playbook: `integrations/mcp-memory/decision-incident-fix-linking.md`
- Calibration workflow: `integrations/mcp-memory/confidence-calibration.md`
- Guardrail workflow: `integrations/mcp-memory/weekly-guardrail-synthesis.md`
