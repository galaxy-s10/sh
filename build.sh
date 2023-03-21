#!/usr/bin/env bash
###
# Author: shuisheng
# Date: 2022-08-15 09:10:56
# Description: https://github.com/galaxy-s10/sh/
# Email: 2274751790@qq.com
# FilePath: /sh/build.sh
# Github: https://github.com/galaxy-s10
# LastEditors: shuisheng
# LastEditTime: 2023-03-21 22:41:35
###

# 生成头部文件快捷键: ctrl+cmd+i

# 静态部署的项目, 一般流程是在jenkins里面执行build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/frontend.sh, frontend.sh会将构建的完成资源复制到/node/xxx
# 复制完成后, frontend.sh会执行清除buff/cache操作

# node项目, 一般流程是在jenkins里面执行build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/node.sh, node.sh会将构建的完成资源复制到/node/xxx, 并且执行/node/xxx/pm2.sh
# 最后, node.sh会执行清除buff/cache操作

# docker项目, 一般流程是在jenkins里面执行build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/docker.sh, 并且执行/node/xxx/docker.sh
# 最后, docker.sh会执行清除buff/cache操作

# 注意: JOBNAME=$1, 这个等号左右不能有空格!
JOBNAME=$1      #约定$1为任务名
ENV=$2          #约定$2为环境
WORKSPACE=$3    #约定$3为Jenkins工作区
PORT=$4         #约定$4为端口号
TAG=$5          #约定$5为git标签
PUBLICDIR=/node #约定公共目录为/node

echo 删除node_modules:
rm -rf node_modules

echo 查看npm版本:
npm -v

echo 设置npm淘宝镜像:
npm config set registry http://registry.npm.taobao.org/

echo 查看当前npm镜像:
npm get registry

if ! type yarn >/dev/null 2>&1; then
    echo yarn未安装,先全局安装yarn
    npm i yarn -g
else
    echo yarn已安装
fi

echo 查看yarn版本:
yarn -v

echo 设置yarn淘宝镜像:
yarn config set registry https://registry.npm.taobao.org

echo 查看当前yarn镜像:
yarn config get registry

echo 开始安装依赖:
npm install

if [ $ENV = 'beta' ]; then
    echo 开始构建测试环境:
elif [ $ENV = 'preview' ]; then
    echo 开始构建预发布环境:
elif [ $ENV = 'prod' ]; then
    echo 开始构建正式环境:
else
    echo 开始构建$ENV环境:
fi

npx cross-env VUE_APP_RELEASE_PUBLICPATH=$JOBNAME VUE_APP_RELEASE_ENV=$ENV webpack --config ./config/webpack.common.js --env production

echo 清除buff/cache:

sync
echo 3 >/proc/sys/vm/drop_caches
