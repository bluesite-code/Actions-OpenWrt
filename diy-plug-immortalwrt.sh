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

# Add alist&mosdns

# 删除旧 golang feed (增强版)
rm -rf feeds/packages/lang/golang 2>/dev/null
echo "🗑️ 已清除旧 Golang feed"

# 克隆新 feed 带重试机制
for i in {1..3}; do
  git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
  if [ $? -eq 0 ]; then
    echo "✅ 第 $i 次尝试：Golang feed 克隆成功"
    break
  else
    echo "⚠️ 第 $i 次尝试：克隆失败，等待 5 秒后重试..."
    sleep 5
    rm -rf feeds/packages/lang/golang  # 清理不完整克隆
  fi
done

# 严格验证克隆结果
if [ -d feeds/packages/lang/golang ]; then
  echo "🔍 新 Golang feed 结构验证："
  ls -l feeds/packages/lang/golang
  echo "--- 关键文件检查 ---"
  [ -f feeds/packages/lang/golang/golang-version.mk ] && echo "✔️ golang-version.mk 存在"
  [ -f feeds/packages/lang/golang/Makefile ] && echo "✔️ Makefile 存在"
else
  echo "❌ 致命错误：Golang feed 替换失败！"
  exit 1
fi

find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
find ./ | grep Makefile | grep alist | xargs rm -f
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/wixxm/WikjxWrt-golang feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
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
