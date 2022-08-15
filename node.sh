#!/usr/bin/env bash
###
# Author: shuisheng
# Email: 2274751790@qq.com
# Github: https://github.com/galaxy-s10
# Date: 2022-01-10 10:56:03
# LastEditTime: 2022-08-15 09:23:46
# Description: 区分环境的node通用构建脚本
###

# 约定$1为任务名, $2为环境, $3为Jenkins工作区, $4为端口号
JOBNAME=$1 # 注意: JOBNAME=$1,这个等号左右不能有空格！
ENV=$2
WORKSPACE=$3
PORT=$4
PUBLICDIR=/node

echo 任务名:$JOBNAME
echo 环境:$JOBNAME
echo 工作区:$WORKSPACE
echo 端口:$PORT

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
    sh $PUBLICDIR/$JOBNAME/$ENV/pm2.sh $JOBNAME $ENV $WORKSPACE $PORT
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
    sh $PUBLICDIR/$JOBNAME/pm2.sh $JOBNAME $ENV $WORKSPACE $PORT
fi
