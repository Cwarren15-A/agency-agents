# Confidence Calibration Workflow (Step 5)

Track predicted confidence against actual outcomes to improve decision quality over time.

## What to Capture

At decision time (Decision Envelope):

- `predicted_confidence_score`: Float `0.0` to `1.0`
- `predicted_confidence_label`: `high | medium | low`
- `decision_id`

At closure time (Outcome Closure):

- `decision_id`
- `outcome_success`: `true | false`
- `severity_if_failed`: `critical | high | medium | low`

## Rules

1. Every high-impact decision must have `predicted_confidence_score`.
2. Every Outcome Closure must include `outcome_success`.
3. Calibration reviews should run weekly.

## Metrics to Track

- Bucket reliability (predicted vs observed success by bucket)
- overconfidence rate (`predicted_confidence_score >= 0.8` but failure)
- underconfidence rate (`predicted_confidence_score <= 0.4` but success)
- Brier score for overall calibration quality

## Output Action

Turn recurring calibration misses into explicit guardrails and add them to agent instructions.
