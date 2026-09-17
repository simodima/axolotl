# 🦎 Axolotl: Retrospective Observer Skill

> *"Like the axolotl—quietly observing, surviving in deep waters, and capable of complete regeneration—Axolotl captures the critical moments of developer friction, breakthrough, and compromise so teams and individuals can learn, adapt, and regenerate."*

**Axolotl** is a self-contained retrospective monitoring and metacognitive observer skill for AI pair programming with **Google Antigravity**. It quietly monitors interaction turns, detects high-signal friction patterns (affective distress, thrashing loops, breakthrough discoveries, cognitive overload, code quality decay, and explicit tech debt compromises), and records structured retrospective notes in `~/.axolotl/notes/`.

The entire skill is packaged as a **single, portable unit** inside [`.agents/skills/axolotl/`](.agents/skills/axolotl/) with zero external system pollution.

---

## 📑 Table of Contents
- [Why Axolotl?](#-why-axolotl)
- [How It Works](#-how-it-works)
- [High-Signal Pattern Taxonomy](#-high-signal-pattern-taxonomy)
- [Skill Unit Structure](#-skill-unit-structure)
- [Storage Initialization](#-storage-initialization)
- [Skill Scripts Reference](#-skill-scripts-reference)
- [Note Schema](#-note-schema)
- [Running Retrospectives](#-running-retrospectives)

---

## 💡 Why Axolotl?

During intense software development, valuable learning moments are constantly generated:
* You spend 2 hours thrashing on a Docker networking bug because of a false assumption.
* You solve a tricky race condition that was a blocker for days (a breakthrough!).
* Under deadline panic, you instruct the AI to bypass auth checks and skip tests.
* You find yourself lost in cognitive fatigue, copy-pasting random snippets without understanding.

Normally, when the session ends, **these lessons vanish**. Axolotl turns these fleeting moments into persistent, structured retrospective notes and actionable discussion prompts for your next personal or team retrospective.

---

## ⚙️ How It Works

Axolotl integrates into Antigravity at three levels:

```
┌────────────────────────────────────────────────────────┐
│             Agent Execution Loop (Antigravity)          │
│                                                        │
│  [User Request] ──> [Reasoning & Tool Execution]       │
│                                   │                    │
│                                   ▼                    │
│                    [End of Chain of Thought]           │
│                                   │                    │
│                    Axolotl Rule Evaluation             │
│                 (Did a high-signal pattern occur?)     │
│                         │                │             │
│                    YES  │                │ NO          │
│                         ▼                ▼             │
│             [Record Note in ~/.axolotl] [Normal Exit]  │
│             [Append Subtle Footer]                     │
└────────────────────────────────────────────────────────┘
```

1. **Workspace Rule ([`.agents/rules/axolotl.md`](.agents/rules/axolotl.md) & [`AGENTS.md`](AGENTS.md))**: Instructs the agent to evaluate the turn at the end of its chain of thoughts.
2. **Skill ([`.agents/skills/axolotl/SKILL.md`](.agents/skills/axolotl/SKILL.md))**: Contains the detailed detection rubric, taxonomy, note templates, and helper scripts.
3. **Skill Scripts ([`.agents/skills/axolotl/scripts/`](.agents/skills/axolotl/scripts/))**: Bundled scripts to initialize storage, record notes, and synthesize retrospectives.

When a note is recorded, the agent appends an unobtrusive footer:
```markdown
> 📝 *Axolotl: recorded retrospective note on [pattern_name]*
```

---

## 🎯 High-Signal Pattern Taxonomy

Axolotl enforces a **selective threshold** to prevent note fatigue. Only high-signal situations trigger notes:

### 1. Affective & Emotional States
| Pattern | ID | Indicators |
| :--- | :--- | :--- |
| **Frustration / Anger** | `affective.frustration` | Irritated tone, snappy instructions, caps, repeated question marks ("Why does this keep failing?!"). |
| **Helplessness / Fatigue** | `affective.helplessness` | Feeling completely stuck ("I've been on this for hours", "I don't know what else to do"), giving up on logic. |
| **Urgency / Panic** | `affective.urgency` | Severe time pressure ("Prod is down", "Demo in 10m"), recklessly skipping verification. |
| **Self-Doubt / Imposter** | `affective.self_doubt` | Over-apologizing ("Sorry for the dumb code"), hesitant outside comfort zone. |
| **Breakthrough & Relief** | `affective.eureka` | Jubilant celebration ("YES! It finally works!"), genuine relief after persistent blockers. |

### 2. Problem-Solving Loops & Breakthroughs
| Pattern | ID | Indicators |
| :--- | :--- | :--- |
| **Thrashing Loop** | `problem_solving.thrashing` | Trying 3+ variations of the same broken fix without questioning foundational assumptions. |
| **Historic First-Time Solve** | `problem_solving.breakthrough` | Overcoming a challenge that was previously an intractable blocker across sessions. |
| **Assumption Collapse** | `problem_solving.assumption_collapse`| Discovering that a core premise (API shape, DB schema, library capability) was false. |
| **Sunk Cost Rabbit Hole** | `problem_solving.rabbit_hole` | Spending excessive effort on a minor side issue that distracts from the core goal. |

### 3. Cognitive & Collaborative Dynamics
| Pattern | ID | Indicators |
| :--- | :--- | :--- |
| **Cognitive Overload / Divergence** | `cognitive.divergence` | Rapidly shifting requirements, jumping abstraction layers, asking for contradictory goals. |
| **Outside Comfort Zone** | `cognitive.comfort_zone` | Forced into an unfamiliar stack or domain (e.g. frontend dev debugging C++ memory leaks). |
| **Mental Model Mismatch** | `cognitive.model_mismatch` | Disconnect between user's mental model and actual system behavior. |

### 4. Codebase Health & Engineering Signals
| Pattern | ID | Indicators |
| :--- | :--- | :--- |
| **Signals of Low Quality** | `codebase_health.decay` | High bug density, absence of tests in critical paths, fragile spaghetti coupling. |
| **Explicit Debt Accumulation** | `codebase_health.explicit_debt`| User explicitly telling agent to skip tests, disable linters, hardcode secrets, or ignore security. |
| **Tooling / Environment Decay**| `codebase_health.tooling_friction` | Flaky CI, broken builds, or package manager hell eating up the majority of dev time. |

---

## 📦 Skill Unit Structure

The skill is completely self-contained within `.agents/skills/axolotl/`:

```text
.agents/skills/axolotl/
├── SKILL.md                  # Main skill rubric & instructions
└── scripts/
    ├── init.sh               # Storage initialization script
    ├── axolotl               # Full CLI toolkit (record, list, view, retro, stats)
    └── record-note.sh        # Fast recording helper wrapper
```

---

## 🚀 Storage Initialization

To initialize the `$HOME/.axolotl/notes` directory:

```bash
./.agents/skills/axolotl/scripts/init.sh
```

This ensures `$HOME/.axolotl/notes` exists without installing any executables into your home directory or altering shell profiles.

---

## 🛠️ Skill Scripts Reference

All operations can be run directly using the scripts inside the skill:

### 1. List Recent Notes
```bash
./.agents/skills/axolotl/scripts/axolotl list
./.agents/skills/axolotl/scripts/axolotl list --limit 10 --category problem_solving
```

### 2. View a Specific Note
```bash
./.agents/skills/axolotl/scripts/axolotl view <note-id-or-partial-slug>
```

### 3. Record a Note
```bash
./.agents/skills/axolotl/scripts/record-note.sh \
  --title "Looping on Docker port collision" \
  --category "problem_solving" \
  --pattern "thrashing_loop" \
  --mood "frustration" \
  --severity "high" \
  --project "axolotl" \
  --tags "docker,ports,debugging" \
  --trigger "Port 8080 binding failed 3 consecutive attempts" \
  --observation "Attempted 3 variations of port remapping without checking lsof" \
  --root-cause "Stale background container was holding the port" \
  --retro-prompt "Why didn't we inspect 'lsof -i :8080' before editing compose files?"
```
*(Running `./.agents/skills/axolotl/scripts/axolotl record` with no arguments launches an interactive prompt).*

### 4. Generate a Retrospective Digest
Synthesizes recent notes, detects recurring bottlenecks, and formats curated retro questions:
```bash
./.agents/skills/axolotl/scripts/axolotl retro
./.agents/skills/axolotl/scripts/axolotl retro --days 30 --project axolotl
```

### 5. View Metrics & Distribution
```bash
./.agents/skills/axolotl/scripts/axolotl stats
```

---

## 📝 Note Schema

Notes are stored as Markdown files with YAML frontmatter in `~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md`:

```markdown
---
id: 2026-09-17_2225_looping_on_docker_port_collision
timestamp: "2026-09-17T22:25:42+0200"
project: "axolotl"
category: "problem_solving"
pattern: "thrashing_loop"
detected_mood: "frustration"
severity: "high"
tags: ["docker", "networking", "loop"]
---

# Retrospective Note: Looping on Docker port collision

## 1. Trigger & Context
Port 8080 binding failed 3 consecutive attempts

## 2. Agent Observation & Signals
Attempted 3 variations of port remapping without checking if another container held the socket

## 3. Underlying Root Cause Hypothesis
Stale background daemon was still holding socket 8080

## 4. Retrospective Prompt for Future You
Why didn't we inspect 'lsof -i :8080' or docker ps before editing compose files?
```

---

## 🔄 Running Retrospectives

Before your weekly team retrospective or personal sprint review, run:

```bash
./.agents/skills/axolotl/scripts/axolotl retro --days 7
```

This generates a structured agenda highlighting:
* **🎉 Breakthroughs & Hard-Won Wins** to celebrate.
* **🔄 Thrashing Loops** to streamline.
* **🧠 Emotional & Cognitive Friction** to support developer well-being.
* **⚠️ Technical Debt Accrued** to prioritize for refactoring.
* **💡 Curated Reflection Questions** to guide high-value discussions.
