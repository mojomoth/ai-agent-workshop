PLAN.md 를 따라 Phase 2 범위만 구현해.

범위:
- src/app/page.tsx: 리뷰 목록을 서버 컴포넌트로 SSR. 지금은 lib/airtable.ts 대신
  mock 배열을 그대로 쓸 것 (TODO 주석으로 표시)
- src/components/ReviewForm.tsx: 'use client' + useState 로 폼. submit 시
  fetch('/api/reviews', {method:'POST'}) 호출 후 router.refresh()
- src/components/ReviewCard.tsx: 제목, 별점(★ 반복), 한줄평 표시
- src/app/api/reviews/route.ts: GET/POST 핸들러. 지금은 메모리 배열에 push/read
  (서버 재시작하면 날아가는 건 Phase 4에서 해결)
- src/lib/airtable.ts: Phase 4 에서 채울 스텁만 export

디자인은 최소한으로 (globals.css 에 reset 수준만). 예쁘게 만들려고 노력하지 마.
Type 은 src/lib/types.ts 의 Review interface 로 통일.

끝나면 `npm run dev` 로 동작 확인한 뒤 커밋: "feat: mvp with mock data"