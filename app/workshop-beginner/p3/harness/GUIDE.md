# Lab 3 — Harness 실습

## Step 3-1.  작업 폴더 준비

```
git init -q
echo "# harness" > README.md
git add . && git commit -q -m "init"
```

## Step 3-2. 컨텍스트 파일(AGENTS.md 또는 CLAUDE.md)로 제약 주입

Claude Code를 쓴다면 CLAUDE.md로, Codex/OpenCode는 AGENTS.md 

## Step 3-3. 결정론적 센서 — 린트·테스트·타입

```
python -m venv .venv && source .venv/bin/activate
pip install -q -r requirements.txt
```

## Step 3-4. pre-commit 훅 — 커밋 게이트

```
cat > .git/hooks/pre-commit <<'EOF'
#!/usr/bin/env bash
set -e
echo "🛡  harness: pre-commit 검증 시작"
source .venv/bin/activate
ruff check . || { echo "❌ ruff 실패 — 커밋 거부"; exit 1; }
pytest -q || { echo "❌ pytest 실패 — 커밋 거부"; exit 1; }
echo "✅ harness: 통과"
EOF
chmod +x .git/hooks/pre-commit
```

## Step 3-5. Harness 위에서 Ralph 재실행

```
./ralph.sh
```

```
tail -f .ralph/log.md
```