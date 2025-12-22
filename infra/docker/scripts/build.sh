#!/bin/bash
# 개별 Docker 이미지 빌드 스크립트

set -e

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 사용법 체크
if [ $# -lt 1 ]; then
    echo "Usage: $0 <image-name> [version] [options]"
    echo ""
    echo "Examples:"
    echo "  $0 n8n-custom"
    echo "  $0 n8n-custom 1.62.0"
    echo "  $0 n8n-custom latest --push"
    echo "  $0 spring-boot-base 3.2.0 --no-cache"
    echo ""
    echo "Available images:"
    for dir in */; do
        if [ -f "${dir}Dockerfile" ]; then
            echo "  - ${dir%/}"
        fi
    done
    exit 1
fi

IMAGE_NAME=$1
VERSION=${2:-latest}
DOCKER_HUB_USER="mindulle"
BUILD_DATE=$(date +%Y%m%d)

# 옵션 파싱
PUSH=false
NO_CACHE=""
for arg in "${@:3}"; do
    case $arg in
        --push)
            PUSH=true
            ;;
        --no-cache)
            NO_CACHE="--no-cache"
            ;;
    esac
done

# 이미지 디렉토리 확인
if [ ! -d "$IMAGE_NAME" ]; then
    echo -e "${RED}Error: Directory '$IMAGE_NAME' not found${NC}"
    exit 1
fi

if [ ! -f "$IMAGE_NAME/Dockerfile" ]; then
    echo -e "${RED}Error: Dockerfile not found in '$IMAGE_NAME'${NC}"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Building Docker Image${NC}"
echo -e "${GREEN}========================================${NC}"
echo "Image: $IMAGE_NAME"
echo "Version: $VERSION"
echo "Build Date: $BUILD_DATE"
echo "Push: $PUSH"
echo ""

# 빌드 인자 설정 (이미지별로 다를 수 있음)
BUILD_ARGS=""
case $IMAGE_NAME in
    n8n-custom)
        BUILD_ARGS="--build-arg N8N_VERSION=$VERSION"
        ;;
    spring-boot-base)
        BUILD_ARGS="--build-arg SPRING_VERSION=$VERSION"
        ;;
    postgres-wal-g)
        BUILD_ARGS="--build-arg POSTGRES_VERSION=$VERSION"
        ;;
esac

# 빌드
echo -e "${YELLOW}Building image...${NC}"
docker build $NO_CACHE \
    $BUILD_ARGS \
    -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest \
    -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION} \
    -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}-${BUILD_DATE} \
    ./${IMAGE_NAME}

echo ""
echo -e "${GREEN}✅ Build completed!${NC}"
echo ""
echo "Tags created:"
echo "  - ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
echo "  - ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}"
echo "  - ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}-${BUILD_DATE}"
echo ""

# 테스트 (선택사항)
read -p "Test the image? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Testing image...${NC}"
    
    case $IMAGE_NAME in
        n8n-custom)
            docker run -d --name test-${IMAGE_NAME} \
                -p 5678:5678 \
                ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
            
            sleep 10
            docker exec test-${IMAGE_NAME} oci --version
            curl -f http://localhost:5678/healthz || echo "Health check failed"
            ;;
        spring-boot-base)
            docker run --rm ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest java -version
            ;;
        *)
            docker run --rm ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest echo "Test OK"
            ;;
    esac
    
    # 정리
    if docker ps -a | grep -q "test-${IMAGE_NAME}"; then
        docker stop test-${IMAGE_NAME} 2>/dev/null || true
        docker rm test-${IMAGE_NAME} 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ Test completed!${NC}"
    echo ""
fi

# 푸시
if [ "$PUSH" = true ]; then
    read -p "Push to Docker Hub? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Pushing images...${NC}"
        docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
        docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}
        docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${VERSION}-${BUILD_DATE}
        echo -e "${GREEN}✅ Push completed!${NC}"
    fi
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Done!${NC}"
echo -e "${GREEN}========================================${NC}"
