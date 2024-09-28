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
#echo 'src-git packages https://github.com/kiddin9/openwrt-packages.git' >>feeds.conf.default
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default

# Add alist&mosdns
#rm -rf feeds/packages/lang/golang
echo 'src-git https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang' >> feeds.conf.default
echo 'src-git https://github.com/sbwml/luci-app-alist package/alist' >> feeds.conf.default
echo 'src-git https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns' >> feeds.conf.default
echo 'src-git https://github.com/sbwml/v2ray-geodata package/v2ray-geodata' >> feeds.conf.default

# Add theme
#echo 'src-git infinityfreedomng https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git' >>feeds.conf.default
#cd fros/package
#echo 'src-git https://github.com/jerrykuku/luci-theme-argon.git' >>feeds.conf.default
