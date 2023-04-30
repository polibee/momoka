#!/bin/bash

# 定义 Momoka 镜像名称和版本
MOMOKA_IMAGE="lensprotocol/momoka"
MOMOKA_VERSION="latest"

# 定义默认端口和备用端口
DEFAULT_PORT="3000"
BACKUP_PORT="3001"

# 检查默认端口是否已被占用，如果被占用则使用备用端口
if [[ $(netstat -nl | grep ":$DEFAULT_PORT") ]]; then
  echo "端口 $DEFAULT_PORT 已被占用，将使用备用端口 $BACKUP_PORT"
  PORT=$BACKUP_PORT
else
  PORT=$DEFAULT_PORT
fi

# 构建 Momoka 镜像
docker build -t $MOMOKA_IMAGE:$MOMOKA_VERSION .

# 运行 Momoka 容器
docker run -d -p $PORT:3000 $MOMOKA_IMAGE:$MOMOKA_VERSION

# 显示 Momoka 容器信息
CONTAINER_ID=$(docker ps -qf "ancestor=$MOMOKA_IMAGE:$MOMOKA_VERSION")
CONTAINER_NAME=$(docker inspect --format '{{.Name}}' $CONTAINER_ID | sed 's/\///')
CONTAINER_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)

echo "Momoka 容器已经启动，端口号为 $PORT"
echo "网页访问地址: http://localhost:$PORT/"
echo "配置修改地址: http://localhost:$PORT/settings"
echo "容器名称: $CONTAINER_NAME"
echo "容器IP地址: $CONTAINER_IP"
