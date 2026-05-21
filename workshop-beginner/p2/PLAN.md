[Plan Mode]

만들 것: "한 줄 영화 리뷰 보드" (Next.js App Router 단일 프로젝트)

요구사항:
- 제목, 평점(1~5), 한 줄평을 입력해 등록
- 등록된 리뷰를 카드 그리드로 표시
- 스택: Next.js 14+ App Router, TypeScript, 서버 컴포넌트 + 클라이언트 컴포넌트 혼용
- DB: Airtable (REST API). 접근은 Next.js Route Handlers 에서만
- 환경변수: .env.local 로 관리, 클라이언트 번들에 노출 금지
- 스타일: DESIGN.md 토큰 기반의 CSS Modules (Tailwind 안 씀)

아직 파일은 하나도 만들지 마. PLAN.md 에 다음만 정리:
1. 최종 파일 트리 (src/app, src/lib, src/components 구분)
2. 각 파일의 책임 한 줄씩
3. 데이터 흐름: 폼 제출 → 어느 경로 → 어디서 Airtable 호출 → 어떻게 재렌더
4. Server Component vs Client Component 구분 근거
5. 구현 순서 (체크박스, 각 15분 내)
6. 위험/결정 필요 사항 (캐시 전략, revalidation, 에러 바운더리)