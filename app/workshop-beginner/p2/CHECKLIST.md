# 최종 점검

## 기능
- [ ] 폼 제출 시 Airtable 에 레코드가 실제로 생긴다
- [ ] 새로고침 후에도 서버에서 SSR 로 목록이 나온다
- [ ] 빈 상태 / 로딩 / 에러 UI 가 구분된다
- [ ] rating 이 1~5 범위를 벗어나면 400 반환

## 보안
- [ ] 브라우저 DevTools → Network 에 airtable.com 호출이 없다
- [ ] `grep -r AIRTABLE_TOKEN .next/static 2>/dev/null` 결과가 비어있다
- [ ] .env.local 은 git 에 없다

## 디자인
- [ ] 모든 색/폰트/간격이 DESIGN.md 의 토큰에서 옴 (하드코딩 grep 통과)
- [ ] 모바일에서 깨지는 레이아웃 없음
- [ ] 다크 테마 토글이 있다면 새로고침 후에도 선택이 유지됨

## 빌드
- [ ] `npm run build` 성공
- [ ] `npm run start` 로 프로덕션 모드에서도 정상 동작
