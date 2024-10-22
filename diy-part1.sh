#!/bin/bash

# 添加自定义源和软件包

# 克隆 fros 项目
git clone https://github.com/bluesite-code/fros -b fros-23.05 package/fros

# 克隆 luci-theme-argon 主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# 克隆 luci-app-fileassistant 文件助手应用
git clone https://github.com/kenzok78/luci-app-fileassistant package/luci-app-fileassistant

# 克隆 luci-app-alist 及其依赖
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
git clone https://github.com/sbwml/luci-app-alist package/alist

# 克隆 luci-app-mosdns 及其依赖
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 如果需要,可以在这里添加更多自定义命令
echo "自定义软件包下载完成"
