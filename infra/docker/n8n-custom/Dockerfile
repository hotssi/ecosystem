# n8n Custom Image with OCI CLI
# Base: Official n8n image

ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}

# 메타데이터
LABEL maintainer="mindulle"
LABEL description="n8n with OCI CLI and custom configurations"
LABEL image="n8n-custom"

# root로 전환하여 패키지 설치
USER root

# Python 및 OCI CLI 설치
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    bash \
    git \
    jq \
    vim \
    && pip3 install --no-cache-dir oci-cli \
    && rm -rf /var/cache/apk/* /root/.cache

# OCI CLI 설정 디렉토리 생성
RUN mkdir -p /home/node/.oci && \
    chown -R node:node /home/node/.oci

# 헬스체크 스크립트 추가
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# node 유저로 복귀
USER node

# 헬스체크 설정
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD /healthcheck.sh

# 기본 n8n 시작 명령어 유지
CMD ["n8n"]
