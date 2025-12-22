# n8n Custom Image

n8n 공식 이미지에 Oracle Cloud Infrastructure (OCI) CLI와 추가 유틸리티를 포함한 커스텀 이미지입니다.

## 포함된 도구

- **OCI CLI**: Oracle Cloud 리소스 관리
- **Python 3**: 스크립트 실행
- **Git**: 버전 관리
- **jq**: JSON 처리
- **vim**: 텍스트 편집
- **bash**: 스크립트 실행

## 빌드

```bash
# 프로젝트 루트에서
./scripts/build.sh n8n-custom

# 또는 이 디렉토리에서
docker build --build-arg N8N_VERSION=latest -t mindulle/n8n-custom:latest .
```

## 사용

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -v ./oci_config:/home/node/.oci:ro \
  mindulle/n8n-custom:latest
```

## OCI CLI 사용

컨테이너 내에서 OCI 명령어 실행:

```bash
docker exec n8n oci compute instance list --compartment-id [OCID]
```

## 환경 변수

- `N8N_BASIC_AUTH_ACTIVE`: 기본 인증 활성화
- `N8N_BASIC_AUTH_USER`: 사용자명
- `N8N_BASIC_AUTH_PASSWORD`: 비밀번호
- `GENERIC_TIMEZONE`: 타임존 (기본: UTC)

자세한 내용은 [n8n 공식 문서](https://docs.n8n.io)를 참고하세요.
