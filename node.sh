#!/usr/bin/env bash
###
# Author: shuisheng
# Date: 2022-04-26 01:54:48
# Description: https://github.com/galaxy-s10/sh/blob/master/node.sh
# Email: 2274751790@qq.com
# FilePath: /github/sh/node.sh
# Github: https://github.com/galaxy-s10
# LastEditTime: 2022-09-03 13:38:07
# LastEditors: shuisheng
###

# 该build.sh文件会在Jenkins构建完成后被执行
# 注意:JOBNAME=$1,这个等号左右不能有空格！
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

echo 进入jenkins工作区:
cd $WORKSPACE

echo 将jenkins工作区的代码复制到node目录

if [ $ENV != 'null' ]; then
    echo 当前环境:$ENV
    if [ -d $PUBLICDIR/$JOBNAME/$ENV ]; then
        echo "$PUBLICDIR/$JOBNAME/$ENV/目录已经存在,先删除它,然后再重新创建它"
        rm -rf $PUBLICDIR/$JOBNAME/$ENV/
        mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
        # 因为ls -A $WORKSPACE拿到的结果是$WORKSPACE里面的东西，因此需要先进入这个$WORKSPACE目录，才能cp里面的文件
        # 上面已经执行了cd $WORKSPACE
        cp -r $(ls -A $WORKSPACE | grep -v .git | xargs) $PUBLICDIR/$JOBNAME/$ENV/
    else
        echo "$PUBLICDIR/$JOBNAME/$ENV/目录还没有,创建它"
        mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
        cp -r $(ls -A $WORKSPACE | grep -v .git | xargs) $PUBLICDIR/$JOBNAME/$ENV/
    fi
    echo "执行$PUBLICDIR/$JOBNAME/$ENV/pm2.sh"
    sh $PUBLICDIR/$JOBNAME/$ENV/pm2.sh $JOBNAME $ENV $WORKSPACE $PORT $TAG
else
    echo 当前环境是null
    if [ -d $PUBLICDIR/$JOBNAME ]; then
        echo "$PUBLICDIR/$JOBNAME/目录已经存在,先删除它,然后再重新创建它"
        rm -rf $PUBLICDIR/$JOBNAME/
        mkdir -p $PUBLICDIR/$JOBNAME/
        cp -r $(ls -A $WORKSPACE | grep -v .git | xargs) $PUBLICDIR/$JOBNAME/
    else
        echo "$PUBLICDIR/$JOBNAME/目录还没有,创建它"
        mkdir -p $PUBLICDIR/$JOBNAME/
        cp -r $(ls -A $WORKSPACE | grep -v .git | xargs) $PUBLICDIR/$JOBNAME/
    fi
    echo "执行$PUBLICDIR/$JOBNAME/$ENV/pm2.sh"
    sh $PUBLICDIR/$JOBNAME/pm2.sh $JOBNAME $ENV $WORKSPACE $PORT $TAG
fi
