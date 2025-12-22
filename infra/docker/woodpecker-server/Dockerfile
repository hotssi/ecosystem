# Woodpecker Server Custom Image
# Base: Official Woodpecker Server

ARG WOODPECKER_VERSION=latest
FROM woodpeckerci/woodpecker-server:${WOODPECKER_VERSION}

# 메타데이터
LABEL maintainer="mindulle"
LABEL description="Woodpecker CI/CD Server with custom configurations"
LABEL image="woodpecker-server"

# 추가 도구 설치 (선택사항)
USER root

# Alpine 패키지 추가 (필요한 경우)
RUN apk add --no-cache \
    curl \
    jq \
    vim \
    bash \
    git \
    && rm -rf /var/cache/apk/*

# 설정 파일 템플릿 복사 (선택사항)
# COPY config/ /etc/woodpecker/

# 헬스체크
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8000/healthz || exit 1

# woodpecker 사용자로 복귀
USER woodpecker

# 기본 포트
EXPOSE 8000 9000

# 시작 명령어 (기본값 유지)
ENTRYPOINT ["/bin/woodpecker-server"]
