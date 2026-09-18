# Workspace Guidelines & Agent Rules

## Axolotl Retrospective Monitoring
This repository has active retrospective monitoring configured via the [Axolotl Skill](skills/axolotl/SKILL.md).

### Turn Evaluation Procedure
- At the end of your chain of thoughts on each turn, automatically evaluate whether an Axolotl high-signal pattern was encountered (Affective/Emotional friction, Thrashing loops, Historic breakthroughs, Cognitive overload, or Codebase quality/debt signals) following the instructions in [skills/axolotl/SKILL.md](skills/axolotl/SKILL.md).
- If triggered:
  - Document the observation in `~/.axolotl/notes/YYYY-MM-DD_HHMM_<slug>.md` using `skills/axolotl/scripts/record-note.sh` or the 4-part retrospective template.
  - Append the subtle one-line footer:
    `> 📝 *Axolotl: recorded retrospective note on [pattern_name]*`
