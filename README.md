# lex-procedural-learning

ACT-R-inspired procedural learning system for the LegionIO cognitive architecture. Tracks skill acquisition from declarative knowledge through to autonomous execution.

## What It Does

Maintains a registry of skills and production rules (condition-action pairs). Skills are practiced with success or failure outcomes, updating proficiency. As proficiency grows, skills advance through three stages: `declarative` (consciously effortful), `associative` (improving), `autonomous` (fast, automatic). Unused skills decay and are pruned over time.

## Usage

```ruby
client = Legion::Extensions::ProceduralLearning::Client.new

# Create a skill
result = client.create_skill(name: 'parse_json_response', domain: :api_handling)
skill_id = result[:skill_id]

# Add production rules to the skill
prod = client.add_skill_production(
  skill_id: skill_id,
  condition: 'response.content_type == application/json',
  action: 'JSON.parse(response.body)',
  domain: :api_handling
)

# Practice the skill (success updates proficiency)
client.practice_skill(skill_id: skill_id, success: true)
# => { success: true, skill_id: ..., proficiency: 0.12, stage: :declarative, stage_label: 'declarative' }

# Execute a production
client.execute_production(production_id: prod[:production_id], success: true)

# Assess skill with all productions
client.skill_assessment(skill_id: skill_id)

# Query by stage
client.compiled_skills    # declarative or autonomous
client.autonomous_skills  # fully automated

# Stats
client.most_practiced_skills(limit: 5)
client.procedural_learning_stats

# Periodic decay and pruning
client.update_procedural_learning
```

## Skill Stages

| Stage | Condition |
|-------|-----------|
| `:declarative` | proficiency < 0.6 |
| `:associative` | proficiency >= 0.6 |
| `:autonomous` | proficiency >= 0.85 |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
