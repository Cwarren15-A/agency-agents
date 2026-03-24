#!/usr/bin/env python3
"""
Compute calibration metrics from decision/outcome records.

Input JSON format (array):
[
  {"decision_id":"d1","predicted_confidence_score":0.9,"outcome_success":true},
  {"decision_id":"d2","predicted_confidence_score":0.6,"outcome_success":false}
]
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from pathlib import Path


def bucket(score: float) -> str:
    if score < 0.4:
        return "low(0.0-0.39)"
    if score < 0.7:
        return "mid(0.4-0.69)"
    return "high(0.7-1.0)"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate confidence calibration report")
    parser.add_argument("input", type=Path, help="Path to input JSON array")
    args = parser.parse_args()

    rows = json.loads(args.input.read_text())
    if not isinstance(rows, list):
        raise SystemExit("Input must be a JSON array.")

    valid = []
    for row in rows:
        if not isinstance(row, dict):
            continue
        if "predicted_confidence_score" not in row or "outcome_success" not in row:
            continue
        score = float(row["predicted_confidence_score"])
        score = min(1.0, max(0.0, score))
        success = bool(row["outcome_success"])
        valid.append((score, success, row.get("decision_id", "unknown")))

    if not valid:
        raise SystemExit("No valid rows with predicted_confidence_score + outcome_success.")

    total = len(valid)
    brier_sum = 0.0
    overconf = 0
    underconf = 0
    buckets: dict[str, list[tuple[float, bool, str]]] = defaultdict(list)

    for score, success, did in valid:
        actual = 1.0 if success else 0.0
        brier_sum += (score - actual) ** 2
        if score >= 0.8 and not success:
            overconf += 1
        if score <= 0.4 and success:
            underconf += 1
        buckets[bucket(score)].append((score, success, did))

    print("Confidence Calibration Report")
    print("============================")
    print(f"Records: {total}")
    print(f"Brier score: {brier_sum / total:.4f}")
    print(f"Overconfidence rate: {overconf / total:.2%}")
    print(f"Underconfidence rate: {underconf / total:.2%}")
    print("")
    print("Bucket reliability")
    for name in sorted(buckets.keys()):
        rows_b = buckets[name]
        n = len(rows_b)
        avg_pred = sum(r[0] for r in rows_b) / n
        obs_success = sum(1 for r in rows_b if r[1]) / n
        print(f"- {name}: n={n}, avg_pred={avg_pred:.3f}, observed_success={obs_success:.3f}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
