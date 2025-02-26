#!/bin/bash
#
# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#echo 'src-git packages https://github.com/kiddin9/kwrt-packages.git' >>feeds.conf.default
#sed -i '1i src-git kenzo https://github.com/kenzok8/small-package' feeds.conf.default
#sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default
#sed -i '1i src-git haibo https://github.com/haiibo/openwrt-packages' feeds.conf.default

# Add fros
git clone https://github.com/bluesite-code/fros -b fros-23.05 package/fros

# 增强版 Golang feed 替换
rm -rf feeds/packages/lang/golang
echo "🔄 开始克隆 Golang 23.x 源..."
if git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang; then
    echo "✅ 克隆成功"
    echo "文件列表："
    ls -l feeds/packages/lang/golang
else
    echo "❌ 克隆失败！请检查："
    echo "1. 分支是否存在：https://github.com/sbwml/packages_lang_golang/tree/23.x"
    echo "2. 网络连接状态"
    exit 1
fi

# Add alist&mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
find ./ | grep Makefile | grep alist | xargs rm -f
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/wixxm/WikjxWrt-golang feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/sbwml/luci-app-alist package/alist

# Add other
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
#git clone https://github.com/kenzok78/luci-app-fileassistant package/luci-app-fileassistant
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset

# Add theme
#echo 'src-git infinityfreedomng https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git' >>feeds.conf.default
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
