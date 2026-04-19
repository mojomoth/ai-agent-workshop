# Lab 2 — Ralph 루프 실습

## Step 2-1. 작업 폴더 준비

```
git init -q
echo "# ralph loop" > README.md
git add . && git commit -q -m "init"
```

## Step 2-2. Ralph의 두 핵심 파일

STATUS.md, PLAN.md

## Step 2-3. Ralph 루프 스크립트

```
./ralph.sh
```

```
watch -n 2 'echo "=== PLAN ==="; cat PLAN.md; echo; echo "=== STATUS ==="; cat STATUS.md 2>/dev/null; echo; echo "=== COMMITS ==="; git log --oneline'
```