# ASCII Zoo Builder — Ralph Loop Task

You are building an ASCII art zoo, **one animal at a time**.

## Process (every iteration)

1. **Read `ZOO.md`** to see which animals are already done.
2. **Pick the next animal** from the TODO list (in order).
3. **Create `animals/<name>.txt`** with your ASCII art.
4. **Validate it**: run `python validate.py animals/<name>.txt`
   - If validation fails, fix the file and re-run until it passes.
5. **Update `ZOO.md`**: append `- <name> ✓` to the "Done" section.
6. **Show the zoo**: run `python show_zoo.py` to admire your work.
7. **If all 10 animals are done**, output exactly:
   `<promise>ZOO_COMPLETE</promise>`

## Rules

- **One animal per iteration.** Don't try to do multiple in one shot.
- **Each animal must:**
  - Be at most **10 lines tall**
  - Be at most **30 characters wide**
  - Include a label (the animal's name) on the last line
  - Not be empty
- **Don't modify existing files in `animals/`** — once an animal is done, it's done.
- **Don't modify `validate.py`** — it's the guardrail.
- Be creative and make them **recognizable**!

## TODO (in this order)

1. cat
2. dog
3. fish
4. turtle
5. rabbit
6. owl
7. penguin
8. elephant
9. giraffe
10. dragon

## Completion

When `ZOO.md` shows all 10 animals checked off, and only then,
output `<promise>ZOO_COMPLETE</promise>`.
