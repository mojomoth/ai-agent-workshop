이 폴더에서 구현되는 앱은 Next.JS 로 구현해야해
옵션: TypeScript=Yes, ESLint=Yes, Tailwind=No (DESIGN.md 기반 순수 CSS 로 갈 거라서),
src/ dir=Yes, App Router=Yes, import alias=기본(@/*).
실행 명령: `npx create-next-app@latest . --ts --eslint --no-tailwind --src-dir --app --import-alias "@/*"`