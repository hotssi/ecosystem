#!/bin/bash
# Docker 이미지 버전 추적 스크립트

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Docker Images Version Tracker${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# n8n 버전 확인
if [ -d "n8n-custom" ]; then
    echo -e "${YELLOW}📦 n8n-custom${NC}"
    
    # n8n 최신 버전 (GitHub)
    N8N_LATEST=$(curl -s https://api.github.com/repos/n8n-io/n8n/releases/latest | \
        jq -r '.tag_name' | sed 's/n8n@//')
    echo "  Latest n8n: ${N8N_LATEST}"
    
    # Docker Hub 최신 태그
    CUSTOM_LATEST=$(curl -s "https://hub.docker.com/v2/repositories/mindulle/n8n-custom/tags?page_size=10" | \
        jq -r '.results[] | select(.name | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")) | .name' | \
        sort -V | tail -1)
    
    if [ -z "$CUSTOM_LATEST" ]; then
        echo "  Custom Image: Not found (first build needed)"
    else
        echo "  Custom Image: ${CUSTOM_LATEST}"
        
        if [ "$N8N_LATEST" != "$CUSTOM_LATEST" ]; then
            echo -e "  ${YELLOW}⚠️  Update available: ${N8N_LATEST}${NC}"
        else
            echo -e "  ${GREEN}✅ Up to date${NC}"
        fi
    fi
    echo ""
fi

# Spring Boot 버전 확인 (예시)
if [ -d "spring-boot-base" ]; then
    echo -e "${YELLOW}📦 spring-boot-base${NC}"
    
    # Spring Boot 최신 버전
    SPRING_LATEST=$(curl -s https://api.github.com/repos/spring-projects/spring-boot/releases/latest | \
        jq -r '.tag_name' | sed 's/v//')
    echo "  Latest Spring Boot: ${SPRING_LATEST}"
    
    # Custom 이미지 버전
    CUSTOM_SPRING=$(curl -s "https://hub.docker.com/v2/repositories/mindulle/spring-boot-base/tags?page_size=10" | \
        jq -r '.results[] | select(.name | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")) | .name' | \
        sort -V | tail -1)
    
    if [ -z "$CUSTOM_SPRING" ]; then
        echo "  Custom Image: Not found (first build needed)"
    else
        echo "  Custom Image: ${CUSTOM_SPRING}"
        
        if [ "$SPRING_LATEST" != "$CUSTOM_SPRING" ]; then
            echo -e "  ${YELLOW}⚠️  Update available: ${SPRING_LATEST}${NC}"
        else
            echo -e "  ${GREEN}✅ Up to date${NC}"
        fi
    fi
    echo ""
fi

# 로컬 이미지 목록
echo -e "${YELLOW}📋 Local Images${NC}"
docker images mindulle/* --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}" 2>/dev/null || \
    echo "  No local images found"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Done!${NC}"
echo -e "${GREEN}========================================${NC}"

# Discord 알림 (선택사항)
if [ -n "$DISCORD_WEBHOOK_URL" ] && [ "$N8N_LATEST" != "$CUSTOM_LATEST" ]; then
    echo ""
    echo "Sending Discord notification..."
    
    DISCORD_MESSAGE=$(cat <<EOF
{
  "embeds": [{
    "title": "🔔 Docker Image Update Available",
    "description": "New versions are available for custom images.",
    "color": 16776960,
    "fields": [
      {
        "name": "n8n Official",
        "value": "${N8N_LATEST}",
        "inline": true
      },
      {
        "name": "n8n Custom",
        "value": "${CUSTOM_LATEST}",
        "inline": true
      }
    ],
    "footer": {
      "text": "Docker Images Version Tracker"
    },
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  }]
}
EOF
)
    
    curl -H "Content-Type: application/json" \
         -d "$DISCORD_MESSAGE" \
         "$DISCORD_WEBHOOK_URL" 2>/dev/null || true
fi
