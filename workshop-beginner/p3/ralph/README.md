# todo CLI

로컬 JSON 파일(`db.json`)에 할 일을 저장하는 간단한 커맨드라인 도구입니다.

## 설치

Python 3.8 이상이 필요합니다. 별도의 패키지 설치는 필요 없습니다.

```bash
chmod +x todo.py
```

## 사용법

```
python todo.py <add|list|done|rm> [args]
```

### 명령어

| 명령어 | 설명 |
|--------|------|
| `add <text>` | 새 할 일 추가 |
| `list` | 전체 목록 출력 |
| `done <id>` | 완료 표시 |
| `rm <id>` | 삭제 |

## 시연

```
$ python todo.py add 장보기
Added #1: 장보기

$ python todo.py add 운동하기
Added #2: 운동하기

$ python todo.py add 책 읽기
Added #3: 책 읽기

$ python todo.py list
[ ] #1: 장보기
[ ] #2: 운동하기
[ ] #3: 책 읽기

$ python todo.py done 1
Done #1: 장보기

$ python todo.py list
[x] #1: 장보기
[ ] #2: 운동하기
[ ] #3: 책 읽기

$ python todo.py rm 2
Removed #2: 운동하기

$ python todo.py list
[x] #1: 장보기
[ ] #3: 책 읽기
```

## 테스트

```bash
pytest test_todo.py
```
