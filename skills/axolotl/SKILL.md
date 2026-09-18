---
name: axolotl
description: >-
  Retrospective observer skill. Automatically triggered at the conclusion of the agent's chain of thoughts on every turn to silently evaluate whether high-signal friction, breakthrough, or code quality patterns occurred (frustration, helplessness, deadline urgency, thrashing loops, assumption collapse, cognitive overload, code quality decay, explicit debt instructions). Records structured retrospective notes in ~/.axolotl/notes/ and appends a subtle footer.
---

# Axolotl: Retrospective Observer Skill

Like the axolotl—a creature celebrated for quiet observation, resilience, and remarkable regeneration—this skill empowers the agent to act as a thoughtful, metacognitive observer of the developer journey.

During intense development sessions, developers and agents encounter critical friction points, emotional highs and lows, vicious debugging loops, and moments of technical compromise. These moments are usually lost once the session closes. Axolotl captures these pivotal moments as structured retrospective notes in `~/.axolotl/notes/`, transforming real-time struggle and triumph into lasting insight.

The skill is packaged as a **self-contained unit** inside `skills/axolotl/`, storing notes in the user directory `~/.axolotl/notes/` without polluting `$HOME` with external binaries or modifying shell configurations.

---

## ⚡ Automatic Evaluation Workflow (End of Chain of Thought)

This skill is designed to be **automatically triggered and evaluated** at the conclusion of your internal reasoning (chain of thought) for every response turn:

### 1. Silent Signal Check
At the end of your chain of thoughts, review the turn's user input, execution steps, tool results, and conversational context against the high-signal patterns below:
* **Affective & Emotional States**: Frustration/anger, helplessness/cognitive fatigue, deadline panic/urgency, imposter syndrome/self-doubt, breakthrough & relief (eureka).
* **Problem-Solving Loops**: Thrashing (3+ attempts at same failed approach), historic first-time solves, assumption collapse, sunk cost rabbit holes.
* **Cognitive & Collaborative Dynamics**: Divergent/confused requests, operating far outside comfort zone, mental model mismatch.
* **Codebase Health Signals**: Low quality / fragile code decay, explicit instructions to accumulate debt (skipping tests, disabling linters, bypassing security), chronic tooling/environment friction.

### 2. Threshold Filter
* Only log **high-signal, meaningful moments** that offer valuable reflection for a future retrospective.
* Do **not** log routine debugging, expected syntax errors, or everyday progress.

### 3. Action on Trigger
If a high-signal condition is identified:
1. **Record Note**: Document the observation in `~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md` (using `./skills/axolotl/scripts/record-note.sh` or direct file write).
2. **Subtle Footer**: Conclude the user-facing response with the subtle one-line footer:
   ```markdown
   > 📝 *Axolotl: recorded retrospective note on [pattern_name]*
   ```
If no high-signal condition is met, conclude the turn normally without logging or adding any footer.

---

## 🎯 High-Signal Detection Rubric

### 1. Affective & Emotional States (User Experience)
* **Frustration / Irritation (`affective.frustration`)**: Snappy tone, abrupt commands, repeated question marks or caps ("Why does this keep failing?!", "Just make it work already"), exasperation after failed attempts.
* **Helplessness / Cognitive Fatigue (`affective.helplessness`)**: Expressing defeat ("I have no idea what else to try", "I've been on this for 5 hours", "I'm lost"), willingness to accept broken workarounds just to escape.
* **Urgency / Deadline Panic (`affective.urgency`)**: Time-pressure signals ("Prod is down", "Demo in 15 minutes", "Need this right now"), leading to reckless bypassing of testing or safety checks.
* **Self-Doubt / Imposter Syndrome (`affective.self_doubt`)**: Disproportionate apologies ("Sorry for the dumb question", "I probably wrote terrible code"), hesitation when venturing outside comfort zones.
* **Breakthrough & Relief (`affective.eureka`)**: Jubilant shift in tone ("YES! It finally works!", "That was the magic fix!"), genuine relief after persistent roadblocks.

### 2. Problem-Solving Loops & Breakthroughs (Agent & Pair Dynamics)
* **Thrashing Loop (`problem_solving.thrashing`)**: Trying 3+ variations of the same broken fix without stepping back to re-evaluate fundamental assumptions.
* **Historic First-Time Solve (`problem_solving.breakthrough`)**: Cracking a problem that was an acknowledged blocker across multiple sessions or attempts.
* **Assumption Collapse (`problem_solving.assumption_collapse`)**: Discovering that a core premise (e.g. an API contract, library capability, or environment variable) was completely wrong.
* **Sunk Cost Rabbit Hole (`problem_solving.rabbit_hole`)**: Spending disproportionate time and complexity optimizing or debugging a peripheral detail that distracts from the core goal.

### 3. Cognitive & Collaborative Friction (Communication Dynamics)
* **Cognitive Overload / Divergence (`cognitive.divergence`)**: Rapidly shifting requirements, jumping across disparate layers of abstraction, or issuing contradictory instructions in quick succession.
* **Operating Outside Comfort Zone (`cognitive.comfort_zone`)**: The user is forced to navigate a stack or domain they are visibly unfamiliar with (e.g. frontend engineer debugging kernel/network drivers).
* **Mental Model Mismatch (`cognitive.model_mismatch`)**: Disconnect between the user's mental model of the system and the reality of how the code works, leading to surprise and repeated missteps.

### 4. Codebase Health & Engineering Signals (Technical Context)
* **Hard Signals of Low Quality (`codebase_health.decay`)**: High bug recurrence, spaghetti dependencies, brittle coupling where touching one file unexpectedly breaks distant modules, absence of tests.
* **Explicit Debt Accumulation (`codebase_health.explicit_debt`)**: The user explicitly instructs the agent to disable linters, skip tests, bypass security/auth checks, hardcode secrets, or ignore performance warnings.
* **Tooling & Environment Decay (`codebase_health.tooling_friction`)**: Flaky builds, broken package managers, persistent permission issues, or configuration hell consuming more time than writing application logic.

---

## 📁 Storage & Note Structure

Notes are saved in:
```text
~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md
```

### Initializing Storage
Before recording the first note (or to ensure directories exist), run:
```bash
./skills/axolotl/scripts/init.sh
```
This simply creates `~/.axolotl/notes` if it does not already exist.

### Note Schema
```markdown
---
id: YYYY-MM-DD_HHMM_<slug>
timestamp: "2026-09-18T17:30:00+02:00"
project: "<project_name>"
category: "problem_solving" # affective | problem_solving | cognitive | codebase_health
pattern: "thrashing_loop"
detected_mood: "frustration" # frustration | helplessness | urgency | self_doubt | relief | neutral
severity: "high"            # low | medium | high | critical
tags: ["tag1", "tag2"]
---

# Retrospective Note: <Title>

## 1. Trigger & Context
What triggered this note? Briefly summarize the user prompt, failing command, or context that exposed the pattern.

## 2. Agent Observation & Signals
What specific evidence or behaviors indicated this pattern? (e.g. 3 failed test iterations, angry punctuation, explicit request to skip security).

## 3. Underlying Root Cause Hypothesis
Why did this happen? (e.g. lack of documentation, cognitive fatigue, misleading error message, missing automated regression test).

## 4. Retrospective Prompt for Future You
A probing question or takeaway for the next team or personal retrospective (e.g., "What safety net would have caught this in 2 minutes instead of 45 minutes?").
```

---

## 🛠️ Skill Scripts Reference

All executable tools are bundled within [`skills/axolotl/scripts/`](./scripts/):

- [**`scripts/init.sh`**](./scripts/init.sh): Creates the `$HOME/.axolotl/notes` directory.
- [**`scripts/record-note.sh`**](./scripts/record-note.sh): Fast wrapper to record a retrospective note.
- [**`scripts/axolotl`**](./scripts/axolotl): Complete retrospective toolkit (`record`, `list`, `view`, `retro`, `stats`).

### Recording Example
```bash
./skills/axolotl/scripts/record-note.sh \
  --title "Looping on Docker networking bridge" \
  --category "problem_solving" \
  --pattern "thrashing_loop" \
  --mood "frustration" \
  --severity "high" \
  --project "axolotl" \
  --tags "docker,networking,loop" \
  --trigger "Port binding failed 3 times despite changing ports" \
  --observation "Attempted 3 variations of docker-compose port mapping without checking iptables" \
  --root-cause "Assumed container port mismatch; actual cause was a stale container holding the socket" \
  --retro-prompt "Why didn't we inspect 'lsof -i :8080' or running docker containers before editing compose files?"
```
*(Or use direct file creation if running offline or in read-only script mode).*

---

## 💡 Guidelines for Quality Retrospectives
* **Empathetic & Non-judgmental**: Document human emotions objectively with empathy, never with blame or condescension.
* **Action-oriented**: The "Retrospective Prompt" must provoke useful systemic reflection (e.g. better tooling, documentation, breaks, architecture) rather than superficial fixes.
* **Keep It Flowing**: Do not halt or derail the user's workflow to talk about the note unless the user brings it up. The subtle footer is all that is needed.
