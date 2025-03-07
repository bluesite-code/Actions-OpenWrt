#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: DIY_P1_SH
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#echo 'src-git packages https://github.com/kiddin9/kwrt-packages.git' >>feeds.conf.default
#sed -i '1i src-git kenzo https://github.com/kenzok8/small-package' feeds.conf.default
#sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default
#sed -i '1i src-git haibo https://github.com/haiibo/openwrt-packages' feeds.conf.default

# Add fros
git clone https://github.com/bluesite-code/fros -b fros-23.05 package/fros

# Add alist&mosdns
sudo rm -rf feeds/packages/lang/golang
sudo rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/sbwml/luci-app-alist package/alist

# Add other
#git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
#git clone https://github.com/wangqn/luci-app-filebrowser package/luci-app-filebrowser
git clone https://github.com/kenzok78/luci-app-fileassistant package/luci-app-fileassistant

# Add theme
#echo 'src-git infinityfreedomng https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git' >>feeds.conf.default
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# Make sure all operations are performed in the correct directory
#cd "$GITHUB_WORKSPACE/openwrt" || exit
