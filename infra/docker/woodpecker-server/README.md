# Woodpecker Server Custom Image

Woodpecker CI/CD Server 공식 이미지에 추가 도구를 포함한 커스텀 이미지입니다.

## 포함된 도구

- **curl**: HTTP 요청
- **jq**: JSON 처리
- **vim**: 텍스트 편집
- **bash**: 스크립트 실행
- **git**: 버전 관리

## 빌드

```bash
# 프로젝트 루트에서
./scripts/build.sh woodpecker-server

# 특정 버전
./scripts/build.sh woodpecker-server 2.3.0

# 또는 이 디렉토리에서
docker build --build-arg WOODPECKER_VERSION=latest -t mindulle/woodpecker-server:latest .
```

## 사용

### Docker Compose (권장)

```yaml
version: '3.8'

services:
  woodpecker-server:
    image: mindulle/woodpecker-server:latest
    container_name: woodpecker-server
    restart: unless-stopped
    ports:
      - "8000:8000"  # HTTP
      - "9000:9000"  # gRPC (Agent 통신)
    environment:
      # GitHub OAuth
      - WOODPECKER_GITHUB=true
      - WOODPECKER_GITHUB_CLIENT=${GITHUB_CLIENT_ID}
      - WOODPECKER_GITHUB_SECRET=${GITHUB_CLIENT_SECRET}
      
      # Server 설정
      - WOODPECKER_HOST=https://ci.sonagi.space
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      
      # 데이터베이스 (선택사항)
      # - WOODPECKER_DATABASE_DRIVER=postgres
      # - WOODPECKER_DATABASE_DATASOURCE=postgres://...
      
      # 관리자
      - WOODPECKER_ADMIN=YOUR_GITHUB_USERNAME
    volumes:
      - woodpecker_data:/var/lib/woodpecker

volumes:
  woodpecker_data:
```

### Standalone

```bash
docker run -d \
  --name woodpecker-server \
  -p 8000:8000 \
  -p 9000:9000 \
  -e WOODPECKER_GITHUB=true \
  -e WOODPECKER_GITHUB_CLIENT=${GITHUB_CLIENT_ID} \
  -e WOODPECKER_GITHUB_SECRET=${GITHUB_CLIENT_SECRET} \
  -e WOODPECKER_HOST=https://ci.sonagi.space \
  -e WOODPECKER_AGENT_SECRET=${AGENT_SECRET} \
  -e WOODPECKER_ADMIN=YOUR_GITHUB_USERNAME \
  -v woodpecker_data:/var/lib/woodpecker \
  mindulle/woodpecker-server:latest
```

## 환경 변수

### 필수

- `WOODPECKER_HOST`: 서버 URL (예: https://ci.sonagi.space)
- `WOODPECKER_AGENT_SECRET`: Agent 인증 시크릿 (랜덤 문자열)
- `WOODPECKER_ADMIN`: 관리자 GitHub 사용자명

### GitHub OAuth (권장)

- `WOODPECKER_GITHUB`: GitHub 연동 활성화 (true)
- `WOODPECKER_GITHUB_CLIENT`: GitHub OAuth App Client ID
- `WOODPECKER_GITHUB_SECRET`: GitHub OAuth App Client Secret

[GitHub OAuth App 생성 가이드](https://woodpecker-ci.org/docs/administration/vcs/github)

### Gitea OAuth (대안)

- `WOODPECKER_GITEA`: Gitea 연동 활성화 (true)
- `WOODPECKER_GITEA_URL`: Gitea 서버 URL
- `WOODPECKER_GITEA_CLIENT`: Gitea OAuth Client ID
- `WOODPECKER_GITEA_SECRET`: Gitea OAuth Client Secret

### 데이터베이스 (선택사항)

기본값: SQLite (단일 서버에 충분)

PostgreSQL 사용 시:
- `WOODPECKER_DATABASE_DRIVER`: postgres
- `WOODPECKER_DATABASE_DATASOURCE`: postgres://user:pass@host:5432/dbname?sslmode=disable

## Agent 연결

Agent를 추가하려면 `WOODPECKER_AGENT_SECRET`를 공유하세요.

```bash
# Server에서 사용한 AGENT_SECRET와 동일해야 함
docker run -d \
  --name woodpecker-agent \
  -e WOODPECKER_SERVER=woodpecker-server:9000 \
  -e WOODPECKER_AGENT_SECRET=${AGENT_SECRET} \
  -v /var/run/docker.sock:/var/run/docker.sock \
  mindulle/woodpecker-agent:latest
```

## 포트

- **8000**: HTTP (웹 UI)
- **9000**: gRPC (Agent 통신)

## 데이터 저장

- `/var/lib/woodpecker`: 데이터베이스 및 설정 파일

볼륨 마운트를 통해 데이터를 영구 보관하세요.

## 업그레이드

```bash
# 최신 이미지 다운로드
docker-compose pull

# 재시작
docker-compose up -d

# 로그 확인
docker-compose logs -f woodpecker-server
```

## 백업

### SQLite 백업

```bash
# 컨테이너에서 데이터베이스 복사
docker cp woodpecker-server:/var/lib/woodpecker/woodpecker.sqlite ./backup/

# 또는 볼륨 백업
docker run --rm -v woodpecker_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/woodpecker-backup-$(date +%Y%m%d).tar.gz /data
```

## 트러블슈팅

### Agent가 연결되지 않음

1. **AGENT_SECRET 확인**
   ```bash
   docker logs woodpecker-server | grep -i agent
   ```

2. **포트 개방 확인**
   ```bash
   # 9000 포트가 열려 있는지
   netstat -tulpn | grep 9000
   ```

3. **네트워크 연결 확인**
   ```bash
   # Agent에서 Server로 연결 테스트
   nc -zv woodpecker-server 9000
   ```

### 웹 UI 접속 안 됨

1. **포트 확인**
   ```bash
   docker ps | grep woodpecker-server
   ```

2. **로그 확인**
   ```bash
   docker logs woodpecker-server --tail=100
   ```

3. **헬스체크**
   ```bash
   curl http://localhost:8000/healthz
   ```

## 보안 권장사항

1. **AGENT_SECRET**: 강력한 랜덤 문자열 사용
   ```bash
   openssl rand -hex 32
   ```

2. **HTTPS 사용**: Reverse proxy (Nginx/Traefik)로 SSL 설정

3. **방화벽**: 8000, 9000 포트 적절히 제한

4. **정기 업데이트**: Woodpecker 최신 버전 유지

## 참고 링크

- [Woodpecker 공식 문서](https://woodpecker-ci.org/docs)
- [GitHub OAuth 설정](https://woodpecker-ci.org/docs/administration/vcs/github)
- [Woodpecker GitHub](https://github.com/woodpecker-ci/woodpecker)

---

**관련 이미지**: [woodpecker-agent](../woodpecker-agent/README.md)
