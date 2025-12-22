# [Image Name] Custom Image
# Base: [Base Image]

ARG VERSION=latest
FROM [base-image]:${VERSION}

# 메타데이터
LABEL maintainer="mindulle"
LABEL description="[Description of this image]"
LABEL image="[image-name]"

# root로 전환 (필요한 경우)
USER root

# 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 또는 Alpine의 경우
# RUN apk add --no-cache \
#     curl \
#     git

# 설정 파일 복사
# COPY config.conf /etc/app/config.conf

# 헬스체크 (선택사항)
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
#     CMD curl -f http://localhost:8080/health || exit 1

# 기본 사용자로 복귀 (필요한 경우)
# USER [username]

# 포트 노출
# EXPOSE 8080

# 시작 명령어
CMD ["echo", "Replace with actual command"]
