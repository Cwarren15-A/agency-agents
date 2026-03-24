# Global Agent System Layer

This repository keeps specialist agent prompts domain-specific. To avoid changing each agent's operational prompt, apply global intelligence as an additive system layer.

## Additive Memory Intelligence

Load and apply:

- `integrations/mcp-memory/system-memory-intelligence.md`

This layer is mandatory for cross-session reliability and learning loops, but must not replace or rewrite any specialist agent's role prompt.

## Enforcement

Before relying on this layer in production, run:

```bash
./integrations/mcp-memory/scripts/validate-trace-layer.sh
```
