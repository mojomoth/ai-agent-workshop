# URL 단축기

URL을 8자리 코드로 줄이고, 코드로 원본 URL을 복원하는 Python CLI 도구입니다.

## 사용법

### URL 단축

```bash
python3 shorten.py https://example.com/very/long/path
# 출력: a1b2c3d4
```

### 원본 URL 복원

```bash
python3 shorten.py --resolve a1b2c3d4
# 출력: https://example.com/very/long/path
```

## 저장소

단축 코드와 원본 URL은 `db.json` 파일에 저장됩니다.

```json
{
  "a1b2c3d4": "https://example.com/very/long/path"
}
```

## 테스트

```bash
python3 -m pytest test_shorten.py -v
```
