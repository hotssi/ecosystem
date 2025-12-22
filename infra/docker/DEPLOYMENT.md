# Docker Images 모노레포 배포 가이드

## 📋 목차

1. [초기 설정](#초기-설정)
2. [GitHub 설정](#github-설정)
3. [로컬 개발](#로컬-개발)
4. [CI/CD 설정](#cicd-설정)
5. [운영 가이드](#운영-가이드)

---

## 초기 설정

### 1. 리포지토리 생성

```bash
# 로컬에 압축 해제된 디렉토리가 있다고 가정
cd docker-images

# Git 초기화
git init
git add .
git commit -m "Initial commit: Docker images monorepo"

# GitHub에 리포지토리 생성 후
git remote add origin https://github.com/YOUR_USERNAME/docker-images.git
git branch -M main
git push -u origin main
```

### 2. Docker Hub 준비

#### 계정 확인
- Docker Hub 로그인 확인
- 사용자명 확인 (예: `mindulle`)

#### Access Token 생성
1. Docker Hub → Account Settings → Security
2. "New Access Token" 클릭
3. Token Description: `github-actions-docker-images`
4. Access Permissions: **Read & Write**
5. Generate → 토큰 복사 (한 번만 표시됨!)

---

## GitHub 설정

### 1. Secrets 추가

GitHub 리포지토리 → Settings → Secrets and variables → Actions

**필수 Secrets:**
```
DOCKER_HUB_USERNAME: your_dockerhub_username
DOCKER_HUB_TOKEN: [생성한 Access Token]
```

### 2. Actions 활성화

Settings → Actions → General
- "Allow all actions and reusable workflows" 선택
- "Read and write permissions" 선택
- Save

### 3. 첫 워크플로우 실행

```bash
# 방법 1: 파일 변경으로 트리거
echo "# Test" >> n8n-custom/README.md
git add .
git commit -m "Test: Trigger workflow"
git push

# 방법 2: 수동 트리거
# GitHub → Actions → "Build n8n Custom" → Run workflow
```

---

## 로컬 개발

### 1. 스크립트 권한 설정

```bash
chmod +x scripts/*.sh
```

### 2. 개별 이미지 빌드

```bash
# 기본 빌드 (latest)
./scripts/build.sh n8n-custom

# 특정 버전 빌드
./scripts/build.sh n8n-custom 1.62.0

# 캐시 없이 빌드
./scripts/build.sh n8n-custom latest --no-cache

# 빌드 후 푸시
./scripts/build.sh n8n-custom latest --push
```

### 3. 모든 이미지 빌드

```bash
# 모든 이미지 빌드
./scripts/build-all.sh

# 빌드 후 푸시
./scripts/build-all.sh --push
```

### 4. 버전 확인

```bash
# 업스트림 버전 확인
./scripts/check-versions.sh

# Discord 알림 (선택사항)
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK"
./scripts/check-versions.sh
```

---

## CI/CD 설정

### 워크플로우 구조

각 이미지는 독립적인 워크플로우를 가집니다:

```
.github/workflows/
├── build-n8n.yml          # n8n-custom/
├── build-spring.yml       # spring-boot-base/
└── build-postgres.yml     # postgres-wal-g/
```

### 트리거 조건

#### 1. Path Filter (자동)

```yaml
push:
  branches: [main]
  paths:
    - 'n8n-custom/**'
    - '.github/workflows/build-n8n.yml'
```

**예시:**
```bash
# n8n-custom 폴더만 수정
echo "update" >> n8n-custom/README.md
git add . && git commit -m "Update n8n"
git push
# → build-n8n.yml만 실행됨
```

#### 2. Schedule (자동)

```yaml
schedule:
  - cron: '0 2 * * 0'  # 매주 일요일 02:00 UTC
```

#### 3. Manual (수동)

```yaml
workflow_dispatch:
  inputs:
    n8n_version:
      description: 'n8n version'
      required: true
      default: 'latest'
```

**실행 방법:**
```
GitHub → Actions → [워크플로우 선택] → Run workflow
```

### 빌드 프로세스

```
1. Checkout 코드
   ↓
2. Docker Buildx 설정
   ↓
3. Docker Hub 로그인
   ↓
4. 버전 설정
   ↓
5. 빌드 및 푸시
   - latest
   - [version]
   - [version]-[date]
   ↓
6. 이미지 테스트
   ↓
7. 빌드 요약 생성
```

---

## 운영 가이드

### 일상 운영

#### 주간 체크리스트

```bash
# 1. 로컬에서 버전 확인
./scripts/check-versions.sh

# 2. GitHub Actions 상태 확인
# GitHub → Actions → 최근 실행 확인

# 3. Docker Hub 이미지 확인
# https://hub.docker.com/u/mindulle
```

#### 월간 체크리스트

```bash
# 1. 불필요한 로컬 이미지 정리
docker system prune -a

# 2. GitHub Actions 사용량 확인
# Settings → Billing → Actions

# 3. Docker Hub 저장소 정리
# 오래된 태그 삭제 (필요 시)
```

### 새 이미지 추가

#### 1단계: 템플릿 복사

```bash
# 템플릿 복사
cp -r _templates spring-boot-base

# 디렉토리 이동
cd spring-boot-base
```

#### 2단계: Dockerfile 작성

```dockerfile
# Dockerfile 수정
ARG SPRING_VERSION=3.2.0
FROM eclipse-temurin:17-jre-alpine

# ... 커스터마이징
```

#### 3단계: README 작성

```bash
nano README.md
# 이미지 설명, 사용법 작성
```

#### 4단계: GitHub Actions 추가

```bash
# 워크플로우 복사
cp _templates/github-workflow.yml ../.github/workflows/build-spring.yml

# 워크플로우 수정
nano ../.github/workflows/build-spring.yml
# [image-name] → spring-boot-base
# [Image Name] → Spring Boot Base
```

#### 5단계: 로컬 테스트

```bash
# 루트로 이동
cd ..

# 빌드 테스트
./scripts/build.sh spring-boot-base
```

#### 6단계: 커밋 및 푸시

```bash
git add spring-boot-base/
git add .github/workflows/build-spring.yml
git commit -m "Add spring-boot-base image"
git push
# → 자동으로 빌드 시작
```

### 이미지 업데이트

#### 자동 업데이트 (n8n-custom 예시)

```
[일요일 02:00 UTC] GitHub Actions 자동 실행
  ↓
n8n 최신 버전 확인
  ↓
새 버전 있음? → 자동 빌드 및 푸시
  ↓
OCI 인스턴스 업데이트 (수동)
```

**OCI에서:**
```bash
ssh ubuntu@[IP]
cd ~/n8n-custom
docker-compose pull
docker-compose up -d
```

#### 수동 업데이트

```bash
# 1. GitHub Actions 수동 트리거
# Actions → Build n8n Custom → Run workflow
# Version: 1.63.0

# 2. OCI 인스턴스 업데이트
ssh ubuntu@[IP]
cd ~/n8n-custom
docker-compose pull
docker-compose up -d
```

### 롤백

#### Docker Compose 버전 변경

```yaml
# docker-compose.yml
services:
  n8n:
    # image: mindulle/n8n-custom:latest
    image: mindulle/n8n-custom:1.62.0-oci-20251120  # 특정 날짜 버전
```

```bash
docker-compose down
docker-compose up -d
```

---

## 트러블슈팅

### GitHub Actions 빌드 실패

#### 문제: Secrets 없음

```
Error: Username and password required
```

**해결:**
```bash
# Secrets 확인
Settings → Secrets and variables → Actions
# DOCKER_HUB_USERNAME, DOCKER_HUB_TOKEN 있는지 확인
```

#### 문제: 권한 부족

```
Error: denied: requested access to the resource is denied
```

**해결:**
```bash
# Docker Hub Access Token 확인
# Read & Write 권한이 있는지 확인
```

#### 문제: 빌드 타임아웃

```
Error: The job running on runner has exceeded the maximum execution time
```

**해결:**
```yaml
# .github/workflows/build-*.yml
jobs:
  build:
    timeout-minutes: 30  # 기본 60분에서 조정
```

### 로컬 빌드 실패

#### 문제: Docker 데몬 없음

```
Cannot connect to the Docker daemon
```

**해결:**
```bash
# Docker 시작
sudo systemctl start docker

# 사용자 그룹 추가
sudo usermod -aG docker $USER
# 재로그인 필요
```

#### 문제: 캐시 문제

```
Error: failed to solve with frontend dockerfile.v0
```

**해결:**
```bash
# 캐시 없이 빌드
./scripts/build.sh n8n-custom latest --no-cache
```

### 푸시 실패

#### 문제: 인증 실패

```
Error: unauthorized: incorrect username or password
```

**해결:**
```bash
# Docker Hub 재로그인
docker logout
docker login
# Username: mindulle
# Password: [Access Token]
```

---

## 모니터링

### GitHub Actions

```bash
# Actions 탭에서 확인
https://github.com/YOUR_USERNAME/docker-images/actions

# 이메일 알림 설정
Settings → Notifications → Actions
```

### Docker Hub

```bash
# 최근 푸시 확인
https://hub.docker.com/u/mindulle

# Webhook 설정 (선택사항)
Repository → Webhooks → Add webhook
```

### Discord 알림 (선택사항)

```bash
# check-versions.sh에 환경변수 설정
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."

# Cron 설정
crontab -e
0 9 * * 1 cd ~/docker-images && ./scripts/check-versions.sh
```

---

## 보안 체크리스트

### GitHub

- [x] Secrets 설정 완료
- [x] Actions 권한 설정
- [x] Branch protection (선택)
- [x] .gitignore 설정

### Docker

- [x] Access Token 사용 (비밀번호 아님)
- [x] Read & Write 최소 권한
- [x] 정기적인 토큰 교체 (6개월)

### 이미지

- [x] 민감 정보 포함 안 함
- [x] 최소 권한 실행 (USER 설정)
- [x] 헬스체크 포함
- [x] 베이스 이미지 정기 업데이트

---

## FAQ

### Q1: 여러 이미지를 동시에 빌드하나요?

A: 아니요. 각 이미지는 독립적인 워크플로우를 가지며, 해당 폴더가 변경될 때만 빌드됩니다.

### Q2: 빌드 시간은 얼마나 걸리나요?

A: 이미지에 따라 다릅니다:
- n8n-custom: 5-10분
- Spring Boot: 3-5분
- PostgreSQL: 5-8분

### Q3: GitHub Actions 무료 한도는?

A: Public 리포지토리는 무제한, Private는 월 2000분입니다.

### Q4: 로컬 빌드와 GitHub Actions 빌드의 차이는?

A: 동일한 Dockerfile을 사용하므로 결과는 같습니다. GitHub Actions는 자동화와 버전 관리가 편리합니다.

### Q5: 이미지 크기를 줄이려면?

A: 
- Alpine 기반 이미지 사용
- Multi-stage build 활용
- 불필요한 패키지 제거
- 캐시 정리 (`rm -rf /var/cache/*`)

---

## 참고 자료

- [GitHub Actions 문서](https://docs.github.com/actions)
- [Docker Buildx 문서](https://docs.docker.com/buildx/)
- [Docker Hub 문서](https://docs.docker.com/docker-hub/)

---

**작성일**: 2025-12-06  
**최종 업데이트**: 2025-12-06
