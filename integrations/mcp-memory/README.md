# MCP Memory Integration

> Give any agent persistent memory across sessions using the Model Context Protocol (MCP).

## What It Does

By default, agents in The Agency start every session from scratch. Context is passed manually via copy-paste between agents and sessions. An MCP memory server changes that:

- **Cross-session memory**: An agent remembers decisions, deliverables, and context from previous sessions
- **Handoff continuity**: When one agent hands off to another, the receiving agent can recall exactly what was done — no copy-paste required
- **Rollback on failure**: When a QA check fails or an architecture decision turns out wrong, roll back to a known-good state instead of starting over

## Setup

You need an MCP server that provides memory tools. In this environment, the live shared-memory server (`codex-claude-memory`) exposes tools like `store_memory`, `search_memory`, `text_search`, `list_memories`, `update_memory`, `verify_memory`, `archive_memory`, `restore_memory`, `get_history`, and webhook tools.

## Clean Split: Doc Ownership

- This repo (`agency-agents`) owns **agent-facing memory behavior**:
  - additive AGENTS/system layer
  - decision/trace/outcome/linking/calibration/guardrail templates
- Backend memory infra docs (server ops, webhook runbooks, backend policy) live in:
  - [Cwarren15-A/codex-claude-memory](https://github.com/Cwarren15-A/codex-claude-memory)

If you use webhook tools (`register_webhook`, `list_webhooks`, `delete_webhook`, `activate_alert_webhooks`), configure the server with `SUPABASE_SERVICE_ROLE_KEY`. Those operations are server-admin actions and should not run with anon keys.

Add it to your MCP client config (Claude Code, Cursor, etc.):

```json
{
  "mcpServers": {
    "memory": {
      "command": "your-mcp-memory-server",
      "args": []
    }
  }
}
```

Any MCP server with memory CRUD + retrieval tools can work. Check the [MCP ecosystem](https://modelcontextprotocol.io) for available implementations.

## How to Add Memory to Any Agent

To enhance an existing agent with persistent memory, add a **Memory Integration** section to the agent's prompt. This section instructs the agent to use MCP memory tools at key moments.

If you want this behavior across all agents without changing each specialist prompt, use the additive system layer:

- `AGENTS.md` at repo root
- `integrations/mcp-memory/system-memory-intelligence.md`

### The Pattern

```markdown
## Memory Integration

When you start a session:
- Search relevant context from previous sessions using your role and the current project as search terms (`search_memory`, `text_search`, `list_memories`)
- Review any memories tagged with your agent name to pick up where you left off

When you make key decisions or complete deliverables:
- Store the decision or deliverable with descriptive tags (`store_memory`)
- Include enough context that a future session — or a different agent — can understand what was done and why

When handing off to another agent:
- Store your deliverables tagged for the receiving agent
- Include the handoff metadata: what you completed, what's pending, and what the next agent needs to know

When something fails and you need to recover:
- Search for the last known-good state
- Archive superseded/outdated memories and store replacement decisions with `supersedes`
```

### What the Agent Does With This

The LLM will use MCP memory tools automatically when given these instructions:

- `store_memory` — store a decision, deliverable, or context snapshot with tags
- `search_memory` — semantic recall by meaning
- `text_search` — exact/keyword retrieval
- `get_history` — trace supersedes chains

No code changes to the agent files. No API calls to write. The MCP tools handle everything.

## Example: Enhancing the Backend Architect

See [backend-architect-with-memory.md](backend-architect-with-memory.md) for a complete example — the standard Backend Architect agent with a Memory Integration section added.

## Example: Memory-Powered Workflow

See [../../examples/workflow-with-memory.md](../../examples/workflow-with-memory.md) for the Startup MVP workflow enhanced with persistent memory, showing how agents pass context through memory instead of copy-paste.

## Tips

- **Tag consistently**: Use the agent name and project name as tags on every memory. This makes recall reliable.
- **Let the LLM decide what's important**: The memory instructions are guidance, not rigid rules. The LLM will figure out when to remember and what to recall.
- **Decision supersedes is the killer feature**: When plans change, write the new decision with `supersedes` so history stays clear and retrieval quality stays high.

## Decision Envelope Standard (High-Impact Actions)

For deploys, migrations, data deletion, auth changes, and incident hotfixes, require a **Decision Envelope** memory write before execution. This closes the "why did it do that?" gap by preserving rationale and alternatives at decision time.

Use the template: [decision-envelope-template.md](decision-envelope-template.md)

## Trace Metadata + Event Clock

Add trace metadata to memories so decisions are replayable in order:

- `trace_id`
- `step_index`
- `event_ts_utc`
- `actor`

Use the full standard: [trace-metadata-standard.md](trace-metadata-standard.md)

## Outcome Closure (24-72h Learning Loop)

For every high-impact decision, write a follow-up memory in 24-72 hours capturing `expected_outcome` vs `actual_outcome`, incident/rollback status, and timing metrics.

Use the template: [outcome-closure-template.md](outcome-closure-template.md)

## Decision -> Incident -> Fix Linking

When something fails, link the full chain (`decision`, `incident`, `fix`, `outcome closure`) with `link_memories`. This enables one-hop root-cause retrieval and cleaner guardrail generation.

Use the playbook: [decision-incident-fix-linking.md](decision-incident-fix-linking.md)

## Confidence Calibration

Capture predicted confidence on decisions and compare to actual outcomes at closure time. Use this data to identify overconfidence and generate guardrails.

Workflow: [confidence-calibration.md](confidence-calibration.md)  
Helper script: `integrations/mcp-memory/scripts/confidence-calibration-report.py`

## Weekly Guardrail Synthesis

Run a weekly synthesis to convert repeated failures into active operating rules for agents.

Workflow: [weekly-guardrail-synthesis.md](weekly-guardrail-synthesis.md)  
Helper script: `integrations/mcp-memory/scripts/new-guardrail-review.sh`
