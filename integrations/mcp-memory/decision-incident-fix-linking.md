# Decision -> Incident -> Fix Linking Playbook (Step 4)

Use `link_memories` to connect causality every time an incident occurs.

## Link Topology

1. Decision memory (`category=decision`)
2. Incident memory (`category=blocker`)
3. Fix memory (`category=lesson` or `decision`)
4. Outcome Closure memory (`category=lesson`)

All four should be linked bidirectionally through `link_memories`.

## Minimum Metadata and Tags

- `decision_id` tag on decision + fix + closure memories
- `incident_id` tag on incident + fix + closure memories
- `trace_id` in metadata for all linked memories

## Example Operational Flow

1. Store/locate the decision memory.
2. Store incident memory when production issue appears.
3. Store fix memory after mitigation.
4. Store outcome closure memory after 24-72h.
5. Call `link_memories` with all related IDs.

Example:

```json
{
  "memory_ids": [
    "dec_mem_uuid",
    "incident_mem_uuid",
    "fix_mem_uuid",
    "closure_mem_uuid"
  ]
}
```

## Rule

If an incident is not linked to its originating decision and eventual fix, that incident cannot contribute to reliable future retrieval or policy synthesis.
