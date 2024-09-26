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

# Add alist
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# Add mosdns
#git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

# Add theme
#git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
