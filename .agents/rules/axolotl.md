# Rule: Axolotl Retrospective Monitoring

This rule activates the **Axolotl** retrospective evaluation workflow at the completion of reasoning steps.

## Evaluation Workflow (End of Chain of Thought)

At the conclusion of your internal reasoning (chain of thought) for each response, perform this silent evaluation:

1. **Signal Check**: Review the turn's user input, execution steps, tool results, and conversational context against the high-signal patterns in the [axolotl skill](../skills/axolotl/SKILL.md):
   - **Affective & Emotional States**: Frustration/anger, helplessness/cognitive fatigue, deadline panic/urgency, imposter syndrome/self-doubt, breakthrough & relief (eureka).
   - **Problem-Solving Loops**: Thrashing (3+ attempts at same failed approach), historic first-time solves, assumption collapse, sunk cost rabbit holes.
   - **Cognitive & Collaborative Dynamics**: Divergent/confused requests, operating far outside comfort zone, mental model mismatch.
   - **Codebase Health Signals**: Low quality / fragile code decay, explicit instructions to accumulate debt (skipping tests, disabling linters, bypassing security), chronic tooling/environment friction.

2. **Threshold Filter**:
   - Only log **high-signal, meaningful moments** that offer valuable reflection for a future retrospective.
   - Do not log routine debugging, expected syntax errors, or everyday progress.

3. **Action on Trigger**:
   - If a high-signal condition is identified:
     1. Record a structured note in `~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md` (using `~/.axolotl/bin/axolotl record` if available, or direct file write).
     2. Conclude the user-facing response with the subtle footer:
        ```markdown
        > 📝 *Axolotl: recorded retrospective note on [pattern_name]*
        ```
   - If no high-signal condition is met, proceed normally without logging or adding any footer.
