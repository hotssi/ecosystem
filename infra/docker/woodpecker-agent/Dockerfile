# Woodpecker Agent Custom Image
# Base: Official Woodpecker Agent

ARG WOODPECKER_VERSION=latest
FROM woodpeckerci/woodpecker-agent:${WOODPECKER_VERSION}

# 메타데이터
LABEL maintainer="mindulle"
LABEL description="Woodpecker CI/CD Agent with custom tools"
LABEL image="woodpecker-agent"

# 추가 도구 설치
USER root

# Alpine 패키지 추가
RUN apk add --no-cache \
    curl \
    jq \
    vim \
    bash \
    git \
    make \
    && rm -rf /var/cache/apk/*

# 헬스체크 (Agent는 HTTP 서버가 없으므로 프로세스 체크)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD pgrep -f woodpecker-agent || exit 1

# woodpecker 사용자로 복귀
USER woodpecker

# 시작 명령어 (기본값 유지)
ENTRYPOINT ["/bin/woodpecker-agent"]
