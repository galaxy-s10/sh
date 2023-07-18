#!/usr/bin/env bash
###
# Author: shuisheng
# Date: 2022-08-15 09:10:56
# Description: https://github.com/galaxy-s10/sh/
# Email: 2274751790@qq.com
# FilePath: /sh/billd-live.sh
# Github: https://github.com/galaxy-s10
# LastEditors: shuisheng
# LastEditTime: 2023-06-23 03:36:51
###

# 生成头部文件快捷键: ctrl+cmd+i

# node项目, 一般流程是在jenkins里面执行项目里的node-build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/node.sh, node.sh会将构建的完成资源复制到/node/xxx, 并且执行/node/xxx/node-pm2.sh
# 最后, 服务器的/node/sh/node.sh会执行清除buff/cache操作

# 注意: JOBNAME=$1, 这个等号左右不能有空格!
JOBNAME=$1      #约定$1为任务名
ENV=$2          #约定$2为环境
WORKSPACE=$3    #约定$3为Jenkins工作区
PORT=$4         #约定$4为端口号
TAG=$5          #约定$5为git标签
PUBLICDIR=/node #约定公共目录为/node

echo 任务名:$JOBNAME
echo 环境:$JOBNAME
echo Jenkins工作区:$WORKSPACE
echo 端口号:$PORT
echo git标签:$TAG

echo 进入node目录:
cd $PUBLICDIR/$JOBNAME/$ENV

echo 解压dist.tar:

tar -zxvf dist.tar

echo 当前环境:$ENV
sh node-pm2.sh $JOBNAME $ENV $WORKSPACE $PORT $TAG

echo 清除buff/cache:

sync
echo 3 >/proc/sys/vm/drop_caches
