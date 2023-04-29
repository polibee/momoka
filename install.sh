#!/bin/bash

# 克隆 momoka 代码
git clone https://github.com/lens-protocol/momoka.git

# 构建 Docker 镜像
docker build -t momoka .

# 创建 Docker 网络
docker network create momoka-network

# 运行 PostgreSQL 容器
docker run -d --name momoka-postgres --network momoka-network -e POSTGRES_PASSWORD=password -e POSTGRES_DB=momoka -v momoka-postgres-data:/var/lib/postgresql/data postgres:12

# 运行 Redis 容器 
docker run -d --name momoka-redis --network momoka-network redis:6

# 运行 momoka 容器
docker run -d --name momoka \
  --network momoka-network \
  -e DATABASE_URL=postgres://postgres:password@momoka-postgres:5432/momoka \
  -e REDIS_URL=redis://momoka-redis:6379 \
  -v momoka-data:/app/public/uploads \
  -p 3000:3000 \
  momoka

# momoka 应用部署完成
echo "momoka deployed!"
