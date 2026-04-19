Phase 4: Airtable 을 실제로 붙인다.

1) src/lib/airtable.ts 구현:
   - 서버 전용임을 보장하기 위해 파일 최상단에 `import 'server-only'`
   - env 검증 (토큰/Base ID/Table 명 중 하나라도 비면 기동 시 명확히 throw)
   - 함수 2개:
     - listReviews(): Promise<Review[]>
       → GET https://api.airtable.com/v0/{base}/{table}?pageSize=50&sort[0][field]=Rating&sort[0][direction]=desc
       → Airtable 의 records 를 우리 Review 타입({id,title,rating,comment})으로 정규화
     - createReview(input): Promise<Review>
       → POST records, body: { fields: { Title, Rating, Comment } }
   - fetch 옵션: { cache: 'no-store' } 로 기본은 안전하게, ISR 은 page 단에서 다룸
   - Airtable 응답 에러는 status 와 본문을 포함한 Error 로 throw

2) src/app/api/reviews/route.ts 재작성:
   - GET: listReviews() 호출, JSON 반환
   - POST: body 검증 (title 비어있지 않음, rating 1~5 정수, comment 길이 ≤ 280)
     createReview 호출 후 생성 결과 반환. 실패 시 400 / 502 구분.
   - 'export const dynamic = "force-dynamic"' 로 캐시 방지

3) src/app/page.tsx:
   - 서버 컴포넌트 유지. listReviews() 직접 호출 (API 안 거침, 더 빠름)
   - revalidate 전략: 'export const revalidate = 0' 로 SSR 강제
   - 목록이 빈 경우 / 에러 케이스 UI 분기

4) src/components/ReviewForm.tsx:
   - submit 성공 후 router.refresh() 로 서버 컴포넌트 재실행
   - 에러는 inline 표시 (alert 금지)

주의:
- AIRTABLE_TOKEN 은 절대 클라이언트 컴포넌트나 page props 로 전달하지 말 것
- 브라우저 Network 탭에 토큰이 새어나가는지 반드시 직접 확인하고 보고

커밋을 3개로 분리:
1. "feat(lib): airtable client"
2. "feat(api): wire route handler to airtable"
3. "feat(page): SSR reviews list"