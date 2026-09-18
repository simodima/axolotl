---
name: axolotl-monitor
description: >-
  Automatic retrospective monitoring skill. Automatically triggered at the conclusion of the agent's chain of thoughts on every turn to silently evaluate whether high-signal friction, breakthrough, or code quality patterns occurred (frustration, helplessness, deadline urgency, thrashing loops, assumption collapse, cognitive overload, code quality decay, explicit debt instructions). Records structured retrospective notes in ~/.axolotl/notes/ and appends a subtle footer.
---

# Axolotl Retrospective Monitoring Skill

This skill activates the **Axolotl** retrospective evaluation workflow at the completion of reasoning steps. It is designed to be **automatically triggered** at the conclusion of an agent's internal reasoning (chain of thought) for every turn.

---

## ⚡ Evaluation Workflow (End of Chain of Thought)

At the conclusion of your internal reasoning (chain of thought) for each response, perform this silent evaluation:

### 1. Signal Check
Review the turn's user input, execution steps, tool results, and conversational context against the high-signal patterns defined in the [Axolotl Skill](../axolotl/SKILL.md):

* **Affective & Emotional States**:
  - `affective.frustration`: Frustration, anger, snappy tone, all caps, or exasperation after failures.
  - `affective.helplessness`: Defeat, exhaustion, cognitive fatigue, feeling completely stuck.
  - `affective.urgency`: Deadline panic, production outages, rushing, skipping verification.
  - `affective.self_doubt`: Imposter syndrome, excessive apologies, hesitation in unfamiliar territory.
  - `affective.eureka`: Breakthrough, jubilant relief, celebrating a resolved blocker.

* **Problem-Solving Loops**:
  - `problem_solving.thrashing`: Looping 3+ times on the same failing approach without re-evaluating assumptions.
  - `problem_solving.breakthrough`: Solving a problem that was an acknowledged multi-session blocker.
  - `problem_solving.assumption_collapse`: Discovering a core premise or dependency assumption was false.
  - `problem_solving.rabbit_hole`: Sunk cost trap on peripheral details that distract from core goals.

* **Cognitive & Collaborative Dynamics**:
  - `cognitive.divergence`: Cognitive overload, rapidly shifting requirements, contradictory tasks.
  - `cognitive.comfort_zone`: Operating far outside familiar domains (e.g. frontend engineer debugging kernel drivers).
  - `cognitive.model_mismatch`: Divergence between user's mental model and actual system behavior.

* **Codebase Health Signals**:
  - `codebase_health.decay`: High bug recurrence, absence of tests on critical paths, brittle spaghetti coupling.
  - `codebase_health.explicit_debt`: Explicit instruction to skip tests, bypass security, disable linters, or hardcode secrets.
  - `codebase_health.tooling_friction`: Environment decay, broken package managers, flaky CI consuming excessive time.

---

### 2. Threshold Filter
* Only log **high-signal, meaningful moments** that offer genuine value for a future retrospective.
* Do **not** log routine debugging, expected syntax errors, or everyday progress.

---

### 3. Action on Trigger
If a high-signal condition is identified:
1. **Record Note**: Document the observation in `~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md` using:
   - The CLI helper: `skills/axolotl/scripts/record-note.sh`
   - Or direct file write following the schema in [skills/axolotl/SKILL.md](../axolotl/SKILL.md).
2. **Subtle Footer**: Conclude the user-facing response with the subtle one-line footer:
   ```markdown
   > 📝 *Axolotl: recorded retrospective note on [pattern_name]*
   ```

If no high-signal condition is met, proceed normally without logging or adding any footer.
