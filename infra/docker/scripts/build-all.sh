#!/bin/bash
# 모든 Docker 이미지 빌드 스크립트

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Building All Docker Images${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 빌드할 이미지 목록
IMAGES=()

# Dockerfile이 있는 디렉토리 찾기
for dir in */; do
    # _로 시작하는 디렉토리는 제외 (템플릿 등)
    if [[ ! $dir =~ ^_ ]] && [ -f "${dir}Dockerfile" ]; then
        IMAGES+=("${dir%/}")
    fi
done

if [ ${#IMAGES[@]} -eq 0 ]; then
    echo -e "${YELLOW}No images found to build${NC}"
    exit 0
fi

echo "Found ${#IMAGES[@]} image(s) to build:"
for img in "${IMAGES[@]}"; do
    echo "  - $img"
done
echo ""

# 빌드 옵션
PUSH=false
NO_CACHE=""

for arg in "$@"; do
    case $arg in
        --push)
            PUSH=true
            ;;
        --no-cache)
            NO_CACHE="--no-cache"
            ;;
    esac
done

# 각 이미지 빌드
SUCCESS=()
FAILED=()

for IMAGE_NAME in "${IMAGES[@]}"; do
    echo ""
    echo -e "${YELLOW}Building ${IMAGE_NAME}...${NC}"
    echo ""
    
    if ./scripts/build.sh "$IMAGE_NAME" latest $NO_CACHE; then
        SUCCESS+=("$IMAGE_NAME")
    else
        FAILED+=("$IMAGE_NAME")
        echo -e "${RED}Failed to build ${IMAGE_NAME}${NC}"
    fi
done

# 결과 요약
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Build Summary${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

if [ ${#SUCCESS[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Successfully built:${NC}"
    for img in "${SUCCESS[@]}"; do
        echo "  - $img"
    done
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ Failed to build:${NC}"
    for img in "${FAILED[@]}"; do
        echo "  - $img"
    done
    exit 1
fi

# 푸시
if [ "$PUSH" = true ]; then
    echo ""
    read -p "Push all images to Docker Hub? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for IMAGE_NAME in "${SUCCESS[@]}"; do
            echo -e "${YELLOW}Pushing ${IMAGE_NAME}...${NC}"
            docker push mindulle/${IMAGE_NAME}:latest
        done
        echo -e "${GREEN}✅ All images pushed!${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Done!${NC}"
