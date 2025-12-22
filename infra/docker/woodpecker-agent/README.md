# Woodpecker Agent Custom Image

Woodpecker CI/CD Agent 공식 이미지에 추가 도구를 포함한 커스텀 이미지입니다.

## 포함된 도구

- **curl**: HTTP 요청
- **jq**: JSON 처리
- **vim**: 텍스트 편집
- **bash**: 스크립트 실행
- **git**: 버전 관리
- **make**: 빌드 도구

## 빌드

```bash
# 프로젝트 루트에서
./scripts/build.sh woodpecker-agent

# 특정 버전
./scripts/build.sh woodpecker-agent 2.3.0

# 또는 이 디렉토리에서
docker build --build-arg WOODPECKER_VERSION=latest -t mindulle/woodpecker-agent:latest .
```

## 사용

### Docker Compose (권장)

```yaml
version: '3.8'

services:
  woodpecker-agent:
    image: mindulle/woodpecker-agent:latest
    container_name: woodpecker-agent
    restart: unless-stopped
    environment:
      # Server 연결 (필수)
      - WOODPECKER_SERVER=woodpecker-server:9000
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      
      # Agent 설정
      - WOODPECKER_MAX_WORKFLOWS=4  # 동시 실행 워크플로우 수
      - WOODPECKER_FILTER_LABELS=location:instance1  # 선택적 레이블
      
      # Backend 선택 (기본: docker)
      - WOODPECKER_BACKEND=docker
      # - WOODPECKER_BACKEND=local  # 로컬 실행
      # - WOODPECKER_BACKEND=kubernetes  # K8s 클러스터
    volumes:
      # Docker 소켓 마운트 (Docker backend 사용 시 필수)
      - /var/run/docker.sock:/var/run/docker.sock
      
      # 선택사항: 볼륨 캐시
      # - agent_cache:/woodpecker/src

# volumes:
#   agent_cache:
```

### Standalone

```bash
docker run -d \
  --name woodpecker-agent \
  -e WOODPECKER_SERVER=woodpecker-server:9000 \
  -e WOODPECKER_AGENT_SECRET=${AGENT_SECRET} \
  -e WOODPECKER_MAX_WORKFLOWS=4 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  mindulle/woodpecker-agent:latest
```

### 외부 서버에서 Agent 실행 (다른 머신)

```bash
# Server 호스트명 또는 IP 사용
docker run -d \
  --name woodpecker-agent \
  -e WOODPECKER_SERVER=ci.sonagi.space:9000 \
  -e WOODPECKER_AGENT_SECRET=${AGENT_SECRET} \
  -e WOODPECKER_MAX_WORKFLOWS=2 \
  -e WOODPECKER_FILTER_LABELS=location:instance3 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  mindulle/woodpecker-agent:latest
```

## 환경 변수

### 필수

- `WOODPECKER_SERVER`: Server 주소 (예: woodpecker-server:9000)
- `WOODPECKER_AGENT_SECRET`: Server와 동일한 시크릿

### 선택사항

- `WOODPECKER_MAX_WORKFLOWS`: 동시 실행 워크플로우 수 (기본: 1)
- `WOODPECKER_BACKEND`: 실행 백엔드 (docker, local, kubernetes)
- `WOODPECKER_FILTER_LABELS`: Agent 필터링 레이블 (예: location:aws,size:large)
- `WOODPECKER_HEALTHCHECK`: 헬스체크 활성화 (true/false)

## Backend 옵션

### Docker (기본, 권장)

```yaml
environment:
  - WOODPECKER_BACKEND=docker
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

**장점**: 격리된 환경, 클린 빌드  
**단점**: Docker-in-Docker 필요

### Local

```yaml
environment:
  - WOODPECKER_BACKEND=local
```

**장점**: 빠른 실행  
**단점**: 격리 없음, 보안 위험

### Kubernetes

```yaml
environment:
  - WOODPECKER_BACKEND=kubernetes
  - WOODPECKER_BACKEND_K8S_NAMESPACE=woodpecker
```

**장점**: 확장성  
**단점**: K8s 클러스터 필요

## 레이블을 사용한 Agent 필터링

### Server에서 레이블 요구

```yaml
# .woodpecker.yml
pipeline:
  build:
    image: node:18
    commands:
      - npm install
      - npm run build
    # 특정 레이블을 가진 Agent에서만 실행
    when:
      branch: main
    labels:
      location: instance1
      size: large
```

### Agent에서 레이블 제공

```bash
docker run -d \
  --name woodpecker-agent-1 \
  -e WOODPECKER_SERVER=woodpecker-server:9000 \
  -e WOODPECKER_AGENT_SECRET=${AGENT_SECRET} \
  -e WOODPECKER_FILTER_LABELS=location:instance1,size:large \
  -v /var/run/docker.sock:/var/run/docker.sock \
  mindulle/woodpecker-agent:latest
```

## 여러 Agent 실행

동일한 서버에서 여러 Agent를 실행할 수 있습니다:

```yaml
version: '3.8'

services:
  woodpecker-agent-1:
    image: mindulle/woodpecker-agent:latest
    container_name: woodpecker-agent-1
    environment:
      - WOODPECKER_SERVER=woodpecker-server:9000
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      - WOODPECKER_MAX_WORKFLOWS=2
      - WOODPECKER_FILTER_LABELS=priority:high
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  woodpecker-agent-2:
    image: mindulle/woodpecker-agent:latest
    container_name: woodpecker-agent-2
    environment:
      - WOODPECKER_SERVER=woodpecker-server:9000
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      - WOODPECKER_MAX_WORKFLOWS=4
      - WOODPECKER_FILTER_LABELS=priority:low
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

## 리소스 제한

```yaml
services:
  woodpecker-agent:
    image: mindulle/woodpecker-agent:latest
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G
```

## 모니터링

### 로그 확인

```bash
# 실시간 로그
docker logs -f woodpecker-agent

# 마지막 100줄
docker logs woodpecker-agent --tail=100

# 에러만 필터링
docker logs woodpecker-agent 2>&1 | grep -i error
```

### Agent 상태 확인

```bash
# Agent가 Server에 연결되었는지 확인
docker logs woodpecker-agent | grep -i connected

# 실행 중인 워크플로우
docker ps | grep woodpecker
```

### Server UI에서 확인

1. Woodpecker 웹 UI 접속
2. 우측 상단 → Admin → Agents
3. 연결된 Agent 목록 확인

## 트러블슈팅

### Agent가 Server에 연결되지 않음

1. **AGENT_SECRET 확인**
   ```bash
   docker logs woodpecker-agent | grep -i secret
   ```

2. **Server 주소 확인**
   ```bash
   # Agent 컨테이너 내부에서 테스트
   docker exec woodpecker-agent nc -zv woodpecker-server 9000
   ```

3. **방화벽 확인** (다른 머신에서 실행 시)
   ```bash
   # Server 머신에서 9000 포트 개방 확인
   sudo ufw status | grep 9000
   ```

### Docker 소켓 권한 오류

```bash
# Docker 그룹에 woodpecker 사용자 추가 (필요 시)
docker exec -u root woodpecker-agent addgroup woodpecker docker
```

### 워크플로우 실행 실패

1. **로그 확인**
   ```bash
   docker logs woodpecker-agent
   ```

2. **Docker 이미지 Pull 실패**
   ```bash
   # Docker Hub Rate Limit 확인
   docker pull alpine:latest
   ```

3. **디스크 공간 부족**
   ```bash
   df -h
   docker system df
   docker system prune -f
   ```

## OCI Instance 배포 예시

### Instance 2 (Server)

```yaml
# docker-compose.yml
version: '3.8'

services:
  woodpecker-server:
    image: mindulle/woodpecker-server:latest
    container_name: woodpecker-server
    restart: unless-stopped
    ports:
      - "8000:8000"
      - "9000:9000"
    environment:
      - WOODPECKER_HOST=https://ci.sonagi.space
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      - WOODPECKER_GITHUB=true
      - WOODPECKER_GITHUB_CLIENT=${GITHUB_CLIENT}
      - WOODPECKER_GITHUB_SECRET=${GITHUB_SECRET}
      - WOODPECKER_ADMIN=YOUR_USERNAME
    volumes:
      - woodpecker_data:/var/lib/woodpecker

  # 로컬 Agent (선택사항)
  woodpecker-agent-local:
    image: mindulle/woodpecker-agent:latest
    container_name: woodpecker-agent-local
    restart: unless-stopped
    environment:
      - WOODPECKER_SERVER=woodpecker-server:9000
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      - WOODPECKER_MAX_WORKFLOWS=2
      - WOODPECKER_FILTER_LABELS=location:instance2
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - woodpecker-server

volumes:
  woodpecker_data:
```

### Instance 1 (원격 Agent)

```yaml
# docker-compose.yml
version: '3.8'

services:
  woodpecker-agent:
    image: mindulle/woodpecker-agent:latest
    container_name: woodpecker-agent
    restart: unless-stopped
    environment:
      # Instance 2의 Server 주소
      - WOODPECKER_SERVER=ci.sonagi.space:9000
      - WOODPECKER_AGENT_SECRET=${AGENT_SECRET}
      - WOODPECKER_MAX_WORKFLOWS=2
      - WOODPECKER_FILTER_LABELS=location:instance1
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

## 보안 권장사항

1. **Docker 소켓 노출 주의**: Agent는 Docker 소켓에 접근하므로 신뢰할 수 있는 환경에서만 실행

2. **AGENT_SECRET 보안**: 강력한 시크릿 사용
   ```bash
   openssl rand -hex 32
   ```

3. **네트워크 격리**: 가능하면 Docker 네트워크 사용

4. **리소스 제한**: deploy.resources로 CPU/메모리 제한

## 성능 최적화

### 캐시 활용

```yaml
volumes:
  # 빌드 캐시 공유
  - agent_cache:/woodpecker/src
```

### MAX_WORKFLOWS 조정

```bash
# 1GB RAM → MAX_WORKFLOWS=2
# 2GB RAM → MAX_WORKFLOWS=4
# 4GB RAM → MAX_WORKFLOWS=8
```

### 디스크 정리 자동화

```bash
# Cron job으로 매일 정리
0 2 * * * docker system prune -f --volumes
```

## 참고 링크

- [Woodpecker 공식 문서](https://woodpecker-ci.org/docs)
- [Agent 설정](https://woodpecker-ci.org/docs/administration/agent-config)
- [Woodpecker GitHub](https://github.com/woodpecker-ci/woodpecker)

---

**관련 이미지**: [woodpecker-server](../woodpecker-server/README.md)
