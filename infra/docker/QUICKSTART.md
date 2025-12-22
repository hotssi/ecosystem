# 🚀 빠른 시작 가이드 (5분)

Docker 이미지 모노레포를 5분 안에 설정하고 첫 빌드를 실행하는 가이드입니다.

## 📋 사전 준비

- Docker 설치 완료
- Docker Hub 계정
- GitHub 계정

---

## 1️⃣ 압축 해제 (10초)

```bash
tar xzf docker-images-monorepo.tar.gz
cd docker-images
```

## 2️⃣ GitHub 리포지토리 생성 (1분)

### 옵션 A: GitHub CLI 사용

```bash
gh repo create docker-images --public --source=. --remote=origin
git add .
git commit -m "Initial commit: Docker images monorepo"
git push -u origin main
```

### 옵션 B: 웹 브라우저 사용

1. https://github.com/new 접속
2. Repository name: `docker-images`
3. Public 선택
4. "Create repository" 클릭
5. 로컬에서 push:

```bash
git init
git add .
git commit -m "Initial commit: Docker images monorepo"
git remote add origin https://github.com/YOUR_USERNAME/docker-images.git
git branch -M main
git push -u origin main
```

---

## 3️⃣ Docker Hub Access Token 생성 (1분)

1. https://hub.docker.com 로그인
2. Account Settings → Security → New Access Token
3. Description: `GitHub Actions`
4. Permissions: **Read & Write** ✅
5. "Generate" 클릭
6. 토큰 복사 (한 번만 표시됨!)

---

## 4️⃣ GitHub Secrets 설정 (1분)

### 웹 브라우저에서:

1. GitHub 리포지토리 → Settings → Secrets and variables → Actions
2. "New repository secret" 클릭
3. 두 개의 Secret 추가:

```
Name: DOCKER_HUB_USERNAME
Value: YOUR_DOCKER_HUB_USERNAME
```

```
Name: DOCKER_HUB_TOKEN
Value: 3단계에서_복사한_토큰
```

### GitHub CLI 사용:

```bash
gh secret set DOCKER_HUB_USERNAME -b "YOUR_USERNAME"
gh secret set DOCKER_HUB_TOKEN -b "YOUR_TOKEN"
```

---

## 5️⃣ 첫 빌드 실행 (2분)

### 자동 빌드 (Recommended)

Push 하면 자동으로 빌드됩니다:

```bash
# 작은 변경사항 만들기
echo "# Docker Images" >> README.md
git add README.md
git commit -m "Trigger first build"
git push
```

### 수동 트리거

1. GitHub 리포지토리 → Actions
2. 워크플로우 선택 (예: "Build n8n Custom")
3. "Run workflow" → "Run workflow"

---

## ✅ 빌드 확인

### GitHub Actions

1. Actions 탭에서 워크플로우 실행 확인
2. 빌드 로그 실시간 모니터링
3. ✅ 녹색 체크마크 확인

### Docker Hub

1. https://hub.docker.com 접속
2. Repositories → `YOUR_USERNAME/n8n-custom`
3. Tags 확인:
   - `latest`
   - `1.XX.X`
   - `1.XX.X-oci`
   - `1.XX.X-oci-YYYYMMDD`

---

## 🎉 완료! 이제 사용 가능

### 로컬에서 테스트

```bash
# 이미지 다운로드
docker pull YOUR_USERNAME/n8n-custom:latest

# 실행
docker run -p 5678:5678 YOUR_USERNAME/n8n-custom:latest

# 브라우저에서 확인
# http://localhost:5678
```

### OCI 인스턴스에 배포

```bash
# SSH 접속
ssh -i ~/.ssh/oci_key ubuntu@[INSTANCE_IP]

# docker-compose.yml 수정
nano docker-compose.yml
```

```yaml
services:
  n8n:
    image: YOUR_USERNAME/n8n-custom:latest
    # ...
```

```bash
# 배포
docker-compose pull
docker-compose up -d
```

---

## 🗂️ 리포지토리 구조 확인

```bash
tree -L 2
```

**출력:**
```
docker-images/
├── n8n-custom/              # ✅ n8n + OCI CLI
├── woodpecker-server/       # ✅ Woodpecker CI/CD Server
├── woodpecker-agent/        # ✅ Woodpecker CI/CD Agent
├── _templates/              # 새 이미지 템플릿
├── .github/workflows/       # GitHub Actions
├── scripts/                 # 빌드 스크립트
├── README.md                # 전체 가이드
├── DEPLOYMENT.md            # 배포 가이드
├── WOODPECKER_DEPLOYMENT.md # Woodpecker 배포 가이드
└── QUICKSTART.md            # 이 파일
```

---

## 📚 다음 단계

### 즉시 (오늘)

- [x] GitHub 리포지토리 생성
- [x] Docker Hub Token 생성
- [x] GitHub Secrets 설정
- [x] 첫 빌드 실행

### 이번 주

- [ ] n8n-custom OCI 배포
- [ ] Woodpecker Server 배포 ([가이드](./WOODPECKER_DEPLOYMENT.md))
- [ ] 주간 자동 빌드 확인

### 이번 달

- [ ] Woodpecker Agent 추가
- [ ] 추가 이미지 계획 (Spring Boot, PostgreSQL 등)
- [ ] Discord 알림 통합

---

## 🆘 문제 해결

### 빌드 실패

**원인**: Secrets 설정 오류

```bash
# Secrets 확인
gh secret list

# 재설정
gh secret set DOCKER_HUB_TOKEN -b "NEW_TOKEN"
```

### Push 권한 없음

**원인**: Access Token 권한 부족

- Docker Hub → Security → Access Token 삭제
- **Read & Write** 권한으로 재생성
- GitHub Secrets 업데이트

### 워크플로우 실행 안 됨

**원인**: Path filter 설정

- n8n-custom/ 폴더 수정 시 build-n8n.yml만 실행됨
- 워크플로우 파일 수정 시에도 실행됨
- 수동 트리거 사용 가능

---

## 💡 유용한 명령어

```bash
# 로컬 빌드
./scripts/build.sh n8n-custom

# 모든 이미지 빌드
./scripts/build-all.sh --push

# 버전 확인
./scripts/check-versions.sh

# GitHub Actions 상태 확인
gh run list

# 최신 빌드 로그
gh run view --log
```

---

## 📖 더 알아보기

- **전체 가이드**: [README.md](./README.md)
- **배포 가이드**: [DEPLOYMENT.md](./DEPLOYMENT.md)
- **Woodpecker 배포**: [WOODPECKER_DEPLOYMENT.md](./WOODPECKER_DEPLOYMENT.md)
- **구조 시각화**: [STRUCTURE.md](./STRUCTURE.md)

---

**소요 시간**: 약 5분  
**난이도**: ⭐☆☆☆☆  
**마지막 업데이트**: 2025-12-11
