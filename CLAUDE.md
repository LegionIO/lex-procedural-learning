# lex-procedural-learning

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-procedural-learning`
- **Version**: 0.1.0
- **Namespace**: `Legion::Extensions::ProceduralLearning`

## Purpose

ACT-R-inspired procedural learning system. Tracks skill acquisition through three stages (`declarative -> associative -> autonomous`) as skills are practiced. Each skill contains `Production` objects (condition-action rules). Skills and productions can be practiced with success/failure outcomes that update proficiency. Stale/unused skills decay and are pruned.

## Gem Info

- **Homepage**: https://github.com/LegionIO/lex-procedural-learning
- **License**: MIT
- **Ruby**: >= 3.4

## File Structure

```
lib/legion/extensions/procedural_learning/
  version.rb
  client.rb
  helpers/
    constants.rb         # SKILL_STAGES, thresholds, limits
    skill.rb             # Skill class — proficiency tracker with stage transitions
    production.rb        # Production class — condition-action rule with success rate
    learning_engine.rb   # LearningEngine — manages skills + productions
  runners/
    procedural_learning.rb  # Runner module
spec/
  helpers/skill_spec.rb
  helpers/production_spec.rb
  helpers/learning_engine_spec.rb
  runners/procedural_learning_spec.rb
  client_spec.rb
```

## Key Constants

From `Helpers::Constants`:
- `SKILL_STAGES = %i[declarative associative autonomous]`
- `COMPILATION_THRESHOLD = 0.6` (proficiency to advance from declarative -> associative)
- `AUTOMATION_THRESHOLD = 0.85` (proficiency to advance to autonomous)
- `MAX_SKILLS`, `MAX_PRODUCTIONS`, `MAX_HISTORY`
- Decay and proficiency update rates

## Runners

| Method | Key Parameters | Returns |
|---|---|---|
| `create_skill` | `name:`, `domain:` | `{ success:, skill_id:, name:, domain:, proficiency:, stage: }` |
| `add_skill_production` | `skill_id:`, `condition:`, `action:`, `domain:` | `{ success:, production_id:, skill_id: }` |
| `practice_skill` | `skill_id:`, `success:` | `{ success:, skill_id:, proficiency:, stage:, stage_label: }` |
| `execute_production` | `production_id:`, `success:` | `{ success:, production_id:, success_rate: }` |
| `skill_assessment` | `skill_id:` | skill hash + productions + reliable_count + total_executions |
| `compiled_skills` | — | `{ success:, skills:, count: }` |
| `autonomous_skills` | — | `{ success:, skills:, count: }` |
| `most_practiced_skills` | `limit: 5` | `{ success:, skills:, count: }` sorted by practice_count |
| `update_procedural_learning` | — | decay + prune stale — `{ success:, pruned: }` |
| `procedural_learning_stats` | — | total_skills, total_productions, compiled_count, autonomous_count, stage_counts |

## Helpers

### `Helpers::Skill`
Single skill tracker: `id`, `name`, `domain`, `proficiency` (0–1, starts 0), `stage` (`:declarative`), `practice_count`, `last_practiced_at`, production ID list. `practice!(success:)` updates proficiency and checks stage thresholds. `compiled?` = stage in [:associative, :autonomous]. `autonomous?` = stage == :autonomous. `stage_label`. `decay!` reduces proficiency by decay rate.

### `Helpers::Production`
Condition-action rule: `id`, `condition`, `action`, `domain`, `skill_id`, `execution_count`, `successes`. `execute!(success:)` updates counts. `success_rate` = successes / execution_count. `reliable?` = success_rate >= threshold.

### `Helpers::LearningEngine`
Manages `@skills` and `@productions` hashes. `create_skill` evicts oldest if at capacity. `add_production` validates skill_id and capacity. `practice_skill` returns proficiency + current stage. `execute_production` delegates to Production. `skill_assessment` retrieves all productions for skill. `compiled_skills` / `autonomous_skills` / `by_domain` / `most_practiced` filter skill set. `decay_all` decays all skills. `prune_stale` removes skills with proficiency <= 0.02 and their productions.

## Integration Points

- `practice_skill` can receive success signals from `lex-tick`'s `action_selection` phase completion
- `autonomous_skills` feed `lex-volition` as available habitual actions (no deliberation needed)
- `compiled_skills` indicate skills ready for faster execution in `lex-tick`'s `:sentinel` mode
- `update_procedural_learning` called each tick via `lex-cortex` phase handler
- Production condition-action pairs can mirror `lex-coldstart` procedural memory traces

## Development Notes

- Stage thresholds: `COMPILATION_THRESHOLD = 0.6` (declarative -> associative), `AUTOMATION_THRESHOLD = 0.85` (-> autonomous)
- Prune threshold: proficiency <= 0.02 considered stale
- `evict_oldest_skill` removes the skill with the oldest `last_practiced_at` when at capacity
- Production removal cascades when a skill is evicted or pruned
- All state is in-memory; reset on process restart
