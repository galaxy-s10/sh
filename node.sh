#!/usr/bin/env bash
###
# Author: shuisheng
# Email: 2274751790@qq.com
# Github: https://github.com/galaxy-s10
# Date: 2022-01-10 10:56:03
# LastEditTime: 2022-01-16 17:16:27
# Description: 不区分环境的node通用构建脚本
###

# 约定$1为任务名, $2为环境, $3为Jenkins工作区
JOBNAME=$1 # 注意: JOBNAME=$1,这个等号左右不能有空格！
ENV=$2
WORKSPACE=$3
PUBLICDIR=/node

if [ $ENV != 'null' ]; then
    echo 当前环境:$ENV
    if [ -d $PUBLICDIR/$JOBNAME/$ENV ]; then
        echo "$PUBLICDIR/$JOBNAME/$ENV/目录已经存在,先删除它,然后再重新创建它"
        rm -rf $PUBLICDIR/$JOBNAME/$ENV/
        mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
        cp -r $WORKSPACE/* $PUBLICDIR/$JOBNAME/$ENV/
    else
        echo "$PUBLICDIR/$JOBNAME/$ENV/目录还没有,创建它"
        mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
        cp -r $WORKSPACE/* $PUBLICDIR/$JOBNAME/$ENV/
    fi
else
    echo 当前环境是null
    if [ -d $PUBLICDIR/$JOBNAME ]; then
        echo "$PUBLICDIR/$JOBNAME/目录已经存在,先删除它,然后再重新创建它"
        rm -rf $PUBLICDIR/$JOBNAME/
        mkdir -p $PUBLICDIR/$JOBNAME/
        cp -r $WORKSPACE/* $PUBLICDIR/$JOBNAME/
    else
        echo "$PUBLICDIR/$JOBNAME/目录还没有,创建它"
        mkdir -p $PUBLICDIR/$JOBNAME/
        cp -r $WORKSPACE/* $PUBLICDIR/$JOBNAME/
    fi
fi

sh $PUBLICDIR/$JOBNAME/pm2.sh $JOBNAME $ENV $WORKSPACE
