# Global Agent System Layer

This repository keeps specialist agent prompts domain-specific. To avoid changing each agent's operational prompt, apply global intelligence as an additive system layer.

## Additive Cortex Memory Intelligence

Load and apply:

- `integrations/mcp-memory/system-memory-intelligence.md`

This layer is mandatory for cross-session reliability and learning loops, but must not replace or rewrite any specialist agent's role prompt.

Cortex is Cameron's shared semantic memory system. All agents that read or write Cortex must also enforce thread continuity:

- search for prior related memories before storing when the topic may already exist
- link new memories to the existing thread immediately after storing
- do not leave active multi-step threads orphaned in the memory graph

This is part of the intelligence layer, not an optional cleanup step.

All agents should also follow the live write contract for memory compatibility:

- non-context writes need project, tags, and explicit date scope
- decision writes need a `topic:*` tag
- replacement decisions must use `supersedes`
- durable personal observations about Cameron belong under `project: career`

## Enforcement

Before relying on this layer in production, run:

```bash
./integrations/mcp-memory/scripts/validate-trace-layer.sh
```
