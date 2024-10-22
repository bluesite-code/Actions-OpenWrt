#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: DIY_P2_SH
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.61.1/g' package/base-files/files/bin/config_generate

# Modify default：password
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Changes password
#password=$(openssl passwd -1 'admin')
#sed -i "s|root::0:0:99999:7:::|root:$password:0:0:99999:7:::|g" package/base-files/files/etc/shadow

# Modify default theme
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" feeds/luci/collections/luci/Makefile
