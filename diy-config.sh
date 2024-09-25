#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.61.1/g' package/base-files/files/bin/config_generate

# Changes password
#password=$(openssl passwd -1 'admin')
#sed -i "s|root::0:0:99999:7:::|root:$password:0:0:99999:7:::|g" package/base-files/files/etc/shadow

# Modify default theme
#git clone https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
