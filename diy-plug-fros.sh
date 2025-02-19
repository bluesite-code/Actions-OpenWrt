#!/bin/bash
set -x  # 开启调试模式
OPENWRT_ROOT="$1"  # 从工作流传入的路径参数

# 进入 OpenWrt 源码目录
cd "$OPENWRT_ROOT"

# 添加延迟确保 feeds 已初始化
sleep 2

# 添加 FROS
echo "添加 FROS 插件"
git clone https://github.com/bluesite-code/fros -b fros-23.05 package/fros

# 处理 Golang 依赖
echo "更新 Golang 源"
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 添加其他组件
echo "添加 MosDNS 和 Alist"
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/sbwml/luci-app-alist package/alist
find package/ -name Makefile | xargs sed -i 's|../../lang/golang/golang-package.mk|$(TOPDIR)/feeds/packages/lang/golang/golang-package.mk|g'

# 添加 Advanced 插件
echo "添加 Advanced 插件"
git clone https://github.com/sirpdboy/luci-app-advancedplus package/luci-app-advancedplus
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset

# 添加 Argon 主题
echo "添加 Argon 主题"
cd package || exit 1
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git luci-theme-argon
cd .. || exit 1
