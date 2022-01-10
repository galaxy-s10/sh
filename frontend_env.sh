#!/usr/bin/env bash
###
# Author: shuisheng
# Email: 2274751790@qq.com
# Github: https://github.com/galaxy-s10
# Date: 2022-01-10 10:55:54
# LastEditTime: 2022-01-10 17:52:18
# Description: 区分环境的前端通用构建脚本
###

# 约定$1为任务名，$2为Jenkins工作区，$3为环境
JOBNAME=$1 # 注意：JOBNAME=$1，这个等号左右不能有空格！
WORKSPACE=$2
ENV=$3
PUBLICDIR=/node

if [ -d $PUBLICDIR/$JOBNAME/$ENV ]; then
    echo "$PUBLICDIR/$JOBNAME/$ENV/目录已经存在,先删除它,然后再重新创建它"
    rm -rf $PUBLICDIR/$JOBNAME/$ENV/
    mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
    cp -r $WORKSPACE/dist/* $PUBLICDIR/$JOBNAME/$ENV/
else
    echo "$PUBLICDIR/$JOBNAME/$ENV/目录还没有,创建它"
    mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
    cp -r $WORKSPACE/dist/* $PUBLICDIR/$JOBNAME/$ENV/
fi
