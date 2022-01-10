#!/usr/bin/env bash
###
# Author: shuisheng
# Email: 2274751790@qq.com
# Github: https://github.com/galaxy-s10
# Date: 2022-01-10 17:56:45
# LastEditTime: 2022-01-10 18:00:15
# Description: 区分环境的前端通用构建脚本
###

# 约定$1为任务名，$2为Jenkins工作区，$3为环境
JOBNAME=$1 # 注意：JOBNAME=$1，这个等号左右不能有空格！
WORKSPACE=$2
ENV=$3
PUBLICDIR=/node

echo 删除node_modules:
rm -rf node_modules

echo 查看npm版本:
npm -v

echo 设置npm淘宝镜像:
npm config set registry http://registry.npm.taobao.org/

echo 查看当前npm镜像:
npm get registry

echo 开始安装依赖:
npm install

echo 开始构建:
npm run build:$ENV
