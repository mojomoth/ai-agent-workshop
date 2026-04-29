# OpenCode Harness - Execution Guide

## ✅ Setup Complete

All files are now in place for the multi-agent orchestration harness:

```
practice-5-opencode-agent/
├── opencode-config.json          ← Architecture reference (Claude models)
├── mission.md                    ← State tracking template
├── opencode-loop.sh              ← Main harness (5 agents, parallel crawlers)
├── task-tracker.sh               ← Real-time progress monitor
└── .claude/
    └── settings.json             ← PostToolUse hooks for completion detection
```

---

## Quick Test (Dry Run)

Test the harness without making API calls:

```bash
./opencode-loop.sh --dry-run --max-rounds 1
```

**Expected output**: 5 phases (Manager → 3×Crawler → Scheduler → Summarizer → Notifier) execute in dry-run mode, showing what WOULD be called.

---

## Real Execution

### Prerequisites

1. **Claude CLI installed and authenticated**
   ```bash
   claude --version
   # Should show: claude-cli version X.Y.Z
   ```

2. **Optional: Slack webhook for notifications**
   ```bash
   export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
   ```

### Run Full 5-Round Loop

```bash
# Terminal 1: Run the harness
./opencode-loop.sh --max-rounds 5

# Terminal 2: Monitor progress (separate terminal)
./task-tracker.sh
```

**Cost estimate**: ~$2.25 (5 rounds × $0.45/round)
- Manager (sonnet): $0.20/round
- Workers (haiku): $0.25/round

**Time estimate**: ~4 minutes (50s/round × 5 rounds)

### Options

```bash
# Run with different model (cheaper)
./opencode-loop.sh --max-rounds 5 --model haiku

# Run single round for testing
./opencode-loop.sh --max-rounds 1

# Run with detailed output
./opencode-loop.sh --max-rounds 3 2>&1 | tee opencode.log
```

---

## Harness Architecture

### 5 Agents, 5 Phases per Round

#### Phase 1: Manager (Sonnet)
- **Role**: Round orchestration
- **Task**: Parse mission.md, create round plan, validate results
- **Output**: JSON plan (stdout)

#### Phase 2: Crawlers (Haiku) - 3 Parallel Jobs
- **HackerNews Crawler**: Fetch top 5 AI stories
- **Reddit Crawler**: Fetch r/MachineLearning top 5
- **Arxiv Crawler**: Fetch latest 3 LLM papers
- **Output**: JSON items to `/tmp/opencode-{round}/crawl_*.txt`

#### Phase 3: Scheduler (Haiku)
- **Role**: Rate limiting and next-round scheduling
- **Output**: Update `schedule.json`

#### Phase 4: Summarizer (Haiku)
- **Role**: Batch summarization
- **Task**: 8 items → Korean 200-char summaries
- **Output**: JSON summaries to `/tmp/opencode-{round}/summaries.txt`

#### Phase 5: Notifier (Haiku)
- **Role**: Message delivery
- **Task**: Format and send to Slack (if webhook set)
- **Output**: Slack blocks to stdout

### Key Design Decisions

| Aspect | Choice | Why |
|--------|--------|-----|
| Manager Model | Sonnet | Complex orchestration, minimal calls |
| Worker Model | Haiku | 90% Sonnet capability, 3× cheaper |
| Parallelism | 3 crawlers at once | Reduce round time from 3min to 1min |
| State File | mission.md | Human-readable, git-friendly |
| Inter-agent Data | `/tmp/opencode-{round}/` | Simple file passing |

---

## Monitoring Progress

### Real-time Display

Run `task-tracker.sh` in a separate terminal:

```bash
./task-tracker.sh
```

Shows:
- Current round (1/5)
- Phase status (WAITING → RUNNING → COMPLETE)
- Total news items collected
- Elapsed time
- Completion signal detection

### Manual Status Check

```bash
# Current round
grep "### Round" mission.md | grep -v "^---"

# Total news collected
grep "총 뉴스:" mission.md

# Check completion
grep "ALL_ROUND_COMPLETED" mission.md && echo "Done!" || echo "Running..."

# Detailed results
grep -A 20 "최종 결과" mission.md
```

---

## Troubleshooting

### Issue: "claude: command not found"

**Solution**: Install Claude CLI or use `claude -p` directly:

```bash
# Check if available
which claude
# or
claude --version

# If not installed, install via:
# https://github.com/anthropics/claude-code
```

### Issue: "No such file or directory: /tmp/opencode-..."

**Solution**: Harness creates `/tmp/opencode-{PID}/` automatically. If it fails to create, check disk space:

```bash
df -h /tmp
rm -rf /tmp/opencode-*  # Clean up old runs
```

### Issue: Harness stops after 1 round

**Solution**: Check for `ALL_ROUND_COMPLETED` in mission.md (harness auto-adds after max_rounds):

```bash
grep "ALL_ROUND_COMPLETED" mission.md
```

If present, loop detected completion and stopped (expected behavior).

### Issue: Slack messages not sending

**Solution**: Set webhook and verify it works:

```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/..."

# Test webhook (copy from opencode-loop.sh output)
curl -X POST "$SLACK_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{"text":"Test message"}'
```

---

## Cost Tracking

### Actual Cost

After running 5 rounds, check costs:

```bash
# Claude CLI shows token usage
# Rough estimate per round:
# - Manager (sonnet): 1500 input + 500 output tokens ≈ $0.20
# - Crawlers (haiku × 3): 300 input + 200 output ≈ $0.05 each
# - Scheduler (haiku): 200 + 100 ≈ $0.01
# - Summarizer (haiku): 400 + 200 ≈ $0.02
# - Notifier (haiku): 200 + 100 ≈ $0.01
# Total ≈ $0.45/round × 5 = $2.25
```

**To reduce costs**:
```bash
# Use haiku for manager too (riskier but cheaper)
./opencode-loop.sh --max-rounds 5 --model haiku

# Run fewer rounds
./opencode-loop.sh --max-rounds 2
```

---

## Next Steps

### Integration Options

1. **Cron job** (hourly crawls):
   ```bash
   0 * * * * cd /path/to/practice-5 && ./opencode-loop.sh --max-rounds 1
   ```

2. **GitHub Actions** (scheduled CI/CD):
   ```yaml
   schedule:
     - cron: '0 * * * *'  # Hourly
   ```

3. **Ralph + OpenCode** (iterative improvement):
   ```bash
   # Run OpenCode in a ralph loop for continuous improvements
   ./ralph-loop.sh --prompt "Run opencode-loop.sh with latest config"
   ```

### Extending the Harness

- **Add more workers**: Edit `opencode-loop.sh` to spawn more crawler jobs
- **Multi-language summarization**: Add localization worker
- **Database storage**: Replace `/tmp/` with persistent storage
- **Webhook signatures**: Add verification before posting to Slack

---

## Architecture Comparison

### Ralph Loop (Practice 3)
```
Claude → Same Prompt → Repeat 30x → Converge on goal
├─ Single agent
├─ Sequential
└─ Good for iterative improvement
```

### OpenCode (Practice 5)
```
Manager → [Crawler, Scheduler, Summarizer, Notifier] Parallel
├─ 5 specialized agents
├─ Parallel execution
└─ Good for high-throughput batch tasks
```

### Hybrid Pattern (Recommended for Production)
```
Ralph Loop (outer)
  ↓
  Per iteration: OpenCode (inner)
    ↓
    Manager → Workers (parallel)
    ↓
    Results fed back to Ralph for validation
  ↓
  Repeat until goal
```

---

## Success Criteria

Harness is working correctly when:

- ✅ `./opencode-loop.sh --dry-run --max-rounds 1` completes without errors
- ✅ `mission.md` updates with each round completion
- ✅ `task-tracker.sh` shows real-time progress
- ✅ Final `mission.md` contains `✅ ALL_ROUND_COMPLETED`
- ✅ Cost estimate ≤ $0.45/round with sonnet manager
- ✅ Each round completes in 50-80 seconds

---

## References

- **opencode-config.json**: Architecture reference document
- **CLAUDE.md**: Multi-agent role definitions and patterns
- **PROMPT.md**: Detailed agent prompts and examples
- **README.md**: General practice overview
