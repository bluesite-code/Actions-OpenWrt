#!/bin/bash

# === 修改点1：移除会覆盖Go版本的操作 ===
# 原始问题代码：
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 修改后：
# 保留官方Go配置，仅更新v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# === 修改点2：修正依赖关系 ===
# 添加Golang版本锁定（针对第三方包）
sed -i '/golang-package.mk/s/$/\nGO_VERSION:=1.23.6\nGO_EXTRA_ARGS:=-compiler gc/' feeds/packages/lang/golang/golang/Makefile

# === 修改点3：确保所有Go相关包使用系统GOROOT ===
find package/*/ -name Makefile | xargs -i sed -i \
  -e '/golang-package.mk/s#../../lang/golang#$(TOPDIR)/feeds/packages/lang/golang#g' \
  -e '/GO_\(VERSION\|SRC\|PATH\)/d' {}  # 移除版本覆盖

# Add alist&mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/luci-app-alist package/alist

# Add fros
git clone https://github.com/bluesite-code/fros -b fros-23.05 package/fros

# Add other
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
#git clone https://github.com/kenzok78/luci-app-fileassistant package/luci-app-fileassistant

# Add theme
#echo 'src-git infinityfreedomng https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git' >>feeds.conf.default
cd openwrt/package
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git luci-theme-argon
