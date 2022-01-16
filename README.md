# 简介

> 这只是一个备份服务器以及项目里用到的构建脚本的地方

# frontend.sh

> 前端通用构建脚本

# node.sh

> node 通用构建脚本

# build.sh

> 前端通用打包脚本

# pm2.sh

> pm2 维护脚本

# jenkins

## 区分环境

```groovy
if (BRANCH.equals("master")) {
  return ["null","beta","preview","prod"]
} else {
  return ["null","beta","preview"]
}
```

## 构建脚本

```shell
echo 当前路径: $(pwd)

echo 远程 URL（GIT_URL）: $GIT_URL

echo 被检出的提交哈希（GIT_COMMIT）: $GIT_COMMIT

echo 远程分支名称（GIT_BRANCH）: $GIT_BRANCH

echo 分支名（BRANCH_NAME）: $BRANCH_NAME

echo 此构建的项目名称（JOB_NAME）: $JOB_NAME

echo 当前项目工作空间的绝对路径（WORKSPACE）: $WORKSPACE

echo 当前构建的分支: $BRANCH

echo 当前发布的环境: $ENV

echo 当前node版本:

node -v

echo 当前npm版本:

npm -v

echo 开始执行构建脚本:

sh ./build.sh $JOB_NAME $ENV $WORKSPACE

echo 列出当前目录:

ls

```

## ssh操作

```shell
sh /node/sh/frontend.sh $JOB_NAME $ENV $WORKSPACE
```

```shell
sh /node/sh/node.sh $JOB_NAME $ENV $WORKSPACE
```

