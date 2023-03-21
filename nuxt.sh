#!/usr/bin/env bash
###
# Author: shuisheng
# Date: 2022-08-15 09:10:56
# Description: https://github.com/galaxy-s10/sh/
# Email: 2274751790@qq.com
# FilePath: /sh/nuxt.sh
# Github: https://github.com/galaxy-s10
# LastEditors: shuisheng
# LastEditTime: 2023-03-21 22:01:11
###

# 生成头部文件快捷键: ctrl+cmd+i

# 静态部署的项目, 一般流程是在jenkins里面执行build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/frontend.sh, frontend.sh会将构建的完成资源复制到/node/xxx
# 最后, 服务器的/node/sh/frontend.sh会执行清除buff/cache操作

# node项目, 一般流程是在jenkins里面执行build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/node.sh, node.sh会将构建的完成资源复制到/node/xxx, 并且执行/node/xxx/nuxt-pm2.sh
# 最后, 服务器的/node/sh/node.sh会执行清除buff/cache操作

# nuxt项目, 一般流程是在jenkins里面执行nuxt-build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/nuxt.sh, nuxt.sh会将构建的完成资源复制到/node/xxx, 并且执行/node/xxx/nuxt-pm2.sh
# 最后, 服务器的/node/sh/nuxt.sh会执行清除buff/cache操作

# docker项目, 一般流程是在jenkins里面执行docker-build.sh进行构建,
# 构建完成后会连接ssh, 执行/node/sh/docker.sh, 并且执行/node/xxx/docker-run.sh
# 最后, 服务器的/node/sh/docker.sh会执行清除buff/cache操作

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

echo 进入jenkins工作区:
cd $WORKSPACE

echo 将jenkins工作区的代码复制到node目录:

if [ $ENV != 'null' ]; then
    echo 当前环境:$ENV
    if [ -d $PUBLICDIR/$JOBNAME/$ENV ]; then
        echo "$PUBLICDIR/$JOBNAME/$ENV/目录已经存在,先删除它,然后再重新创建它"
        rm -rf $PUBLICDIR/$JOBNAME/$ENV/
        mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
        # 因为ls -A $WORKSPACE拿到的结果是$WORKSPACE里面的东西，因此需要先进入这个$WORKSPACE目录，才能cp里面的文件
        # 上面已经执行了cd $WORKSPACE
        cp -r $(ls -A $WORKSPACE | grep -wv .git | xargs) $PUBLICDIR/$JOBNAME/$ENV/
    else
        echo "$PUBLICDIR/$JOBNAME/$ENV/目录还没有,创建它"
        mkdir -p $PUBLICDIR/$JOBNAME/$ENV/
        cp -r $(ls -A $WORKSPACE | grep -wv .git | xargs) $PUBLICDIR/$JOBNAME/$ENV/
    fi
    echo "执行$PUBLICDIR/$JOBNAME/$ENV/nuxt-pm2.sh"
    sh $PUBLICDIR/$JOBNAME/$ENV/nuxt-pm2.sh $JOBNAME $ENV $WORKSPACE $PORT $TAG
else
    echo 当前环境是null
    if [ -d $PUBLICDIR/$JOBNAME ]; then
        echo "$PUBLICDIR/$JOBNAME/目录已经存在,先删除它,然后再重新创建它"
        rm -rf $PUBLICDIR/$JOBNAME/
        mkdir -p $PUBLICDIR/$JOBNAME/
        cp -r $(ls -A $WORKSPACE | grep -wv .git | xargs) $PUBLICDIR/$JOBNAME/
    else
        echo "$PUBLICDIR/$JOBNAME/目录还没有,创建它"
        mkdir -p $PUBLICDIR/$JOBNAME/
        cp -r $(ls -A $WORKSPACE | grep -wv .git | xargs) $PUBLICDIR/$JOBNAME/
    fi
    echo "执行$PUBLICDIR/$JOBNAME/$ENV/nuxt-pm2.sh"
    sh $PUBLICDIR/$JOBNAME/nuxt-pm2.sh $JOBNAME $ENV $WORKSPACE $PORT $TAG
fi

echo 清除buff/cache:

sync
echo 3 >/proc/sys/vm/drop_caches
