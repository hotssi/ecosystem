#!/bin/sh
# n8n Health Check Script

# n8n API 헬스체크
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678/healthz)

if [ "$response" = "200" ]; then
    exit 0
else
    exit 1
fi
