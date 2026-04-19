# Lab 1 — Autopilot 실습

## Step 1-1. 작업 폴더 준비

```
git init -q
echo "# autopilot lab" > README.md
git add . && git commit -q -m "init"
```

## Step 1-2. 명확한 단일 태스크 정의

git add TASK.md && git commit -q -m "add task"

## Step 1-3. Autopilot 실행

## Step 1-4. 관찰 포인트

```
git log --oneline
ls
cat STATUS.md 2>/dev/null
pytest -q
```
