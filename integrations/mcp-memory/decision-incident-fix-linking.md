# Decision -> Incident -> Fix Linking Playbook (Step 4)

Use `link_memories` to connect causality every time an incident occurs.

This playbook also establishes the broader continuity rule for non-incident threads: if a new memory continues an existing thread, it should not remain unlinked.

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

## Non-Incident Thread Continuity

For ongoing threads that are not incidents, use the same discipline:

1. Search for the existing thread first.
2. Store the new memory.
3. Link the new memory to the prior related memories immediately.

Typical examples:

- job application -> recruiter outreach -> interview -> offer / rejection
- client discovery -> proposal -> implementation -> results
- architecture plan -> implementation update -> lesson learned
- repeated updates on the same project, company, person, or deal

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

If a non-incident thread update is left unlinked, future agents lose continuity and the memory graph stops behaving like an intelligent working history.
