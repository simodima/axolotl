# Workspace Guidelines & Agent Rules

## Axolotl Retrospective Monitoring
This repository has active retrospective monitoring configured via the [Axolotl Skill](.agents/skills/axolotl/SKILL.md) and [Axolotl Rule](.agents/rules/axolotl.md).

### Turn Evaluation Procedure
- At the end of your chain of thoughts on each turn, evaluate whether an Axolotl high-signal pattern was encountered (Affective/Emotional friction, Thrashing loops, Historic breakthroughs, Cognitive overload, or Codebase quality/debt signals).
- If triggered:
  - Document the observation in `~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md` using the 4-part retrospective template or `~/.axolotl/bin/axolotl record`.
  - Append the subtle one-line footer:
    `> 📝 *Axolotl: recorded retrospective note on [pattern_name]*`
