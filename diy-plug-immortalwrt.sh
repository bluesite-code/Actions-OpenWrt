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


# 带错误处理和重试机制的 Golang 源替换

set -e  # 遇到错误立即退出

echo "🗑️ 清理旧 Golang 组件..."
rm -rf feeds/packages/lang/golang

# 防御性目录创建
mkdir -vp feeds/packages/lang/golang

# 克隆参数
REPO_URL="https://github.com/sbwml/packages_lang_golang"
BRANCH="23.x"
TARGET_DIR="feeds/packages/lang/golang"

# 带重试的克隆函数
clone_with_retry() {
    local retries=3
    local delay=5
    for ((i=1; i<=retries; i++)); do
        echo "🔄 尝试克隆第 $i 次 (分支: $BRANCH)"
        if git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$TARGET_DIR"; then
            echo "✅ 克隆成功"
            return 0
        fi
        echo "❌ 克隆失败，${delay}秒后重试..."
        sleep $delay
    done
    return 1
}

# 执行克隆
if ! clone_with_retry; then
    echo "::error::无法克隆仓库，请检查："
    echo "1. 网络连接状态"
    echo "2. 仓库是否存在: $REPO_URL/tree/$BRANCH"
    exit 1
fi

# 关键文件验证
CRITICAL_FILE="golang-version.mk"
if [ ! -f "$TARGET_DIR/$CRITICAL_FILE" ]; then
    echo "::error::关键文件缺失: $CRITICAL_FILE"
    echo "当前目录内容:"
    ls -l "$TARGET_DIR"
    echo "建议检查仓库结构: $REPO_URL/tree/$BRANCH"
    exit 1
fi

echo "🔄 更新 feeds 缓存..."
./scripts/feeds update -a -f
./scripts/feeds install -a -f


# Add alist&mosdns
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
