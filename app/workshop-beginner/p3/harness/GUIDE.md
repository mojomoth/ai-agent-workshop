# Lab 3 — Harness 실습 

## Step 1 — 빈 프로젝트 준비

```
git init -q
echo "# harness" > README.md
git add . && git commit -q -m "init harness"
python3 -m venv .venv && source .venv/bin/activate
pip3 install -q pytest ruff bandit
```