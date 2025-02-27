#!/bin/bash
# 增强版 ImmortalWrt 定制脚本 v2.2

set -euo pipefail

# 替换 Golang 源
function replace_golang() {
    echo "🔄 开始替换 Golang 源..."
    local REPO_URL="https://github.com/sbwml/packages_lang_golang"
    local BRANCH="23.x"
    local TARGET_DIR="feeds/packages/lang/golang"
    local MAX_RETRY=3

    echo "=== 预处理目录结构 ==="
    tree -L 4 feeds/packages/lang || ls -lR feeds/packages/lang

    echo "🗑️ 清理旧组件..."
    rm -rf "$TARGET_DIR"
    mkdir -vp "$TARGET_DIR"

    for ((i=1; i<=MAX_RETRY; i++)); do
        echo "🔄 克隆尝试第 $i 次 ($BRANCH)"
        if git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$TARGET_DIR"; then
            echo "✅ 克隆成功"            
            echo "=== 克隆后目录结构 ==="
            find "$TARGET_DIR" -maxdepth 3 -print
            break
        else
            echo "❌ 克隆失败，5秒后重试..."
            sleep 5
            rm -rf "$TARGET_DIR"
            [ $i -eq $MAX_RETRY ] && { 
                echo "::error::克隆失败！最终目录状态："
                tree -L 5 feeds/packages/lang || true
                exit 1 
            }
        fi
    done

    local CRITICAL_FILES=(
        "$TARGET_DIR/golang-version.mk"
        "$TARGET_DIR/golang-package.mk"
    )
    for file in "${CRITICAL_FILES[@]}"; do
        [ -f "$file" ] || {
            echo "::error::关键文件缺失: $file"
            tree -L 5 feeds/packages/lang
            exit 1
        }
        echo "✅ 验证通过: $file"
    done
}

# 清理冲突组件
function clean_conflicts() {
    echo "🧹 清理 ImmortalWrt 冲突组件..."
    
    echo "▷ 清理 mosdns..."
    find . -type f -path '*/mosdns/Makefile' -print -delete 2>/dev/null || true
    
    echo "▷ 清理 v2ray-geodata..."
    find . -type f -path '*/v2ray-geodata/Makefile' -print -delete 2>/dev/null || true

    echo "=== 二次清理检查 ==="
    find . -type f \( -name "*mosdns*" -o -name "*v2ray-geodata*" \) \
        -exec echo "⚠️ 发现残留: {}" \; \
        -exec rm -fv {} \; 2>/dev/null || true
}

# 添加第三方源到 feeds
function add_custom_feeds() {
    echo "📥 添加第三方软件源..."
    local FEED_CONF="feeds.conf.default"
    
    cp -f "$FEED_CONF" "${FEED_CONF}.bak" 2>/dev/null || true

    declare -A CUSTOM_FEEDS=(
        ["fros"]="src-git fros https://github.com/bluesite-code/fros;fros-23.05"
        ["mosdns"]="src-git mosdns https://github.com/sbwml/luci-app-mosdns;v5"
        ["alist"]="src-git alist https://github.com/sbwml/luci-app-alist"
        ["luci-advanced"]="src-git luci-advanced https://github.com/sirpdboy/luci-app-advanced"
        ["luci-autotimeset"]="src-git luci-autotimeset https://github.com/sirpdboy/luci-app-autotimeset"
        ["argon-theme"]="src-git argon-theme https://github.com/jerrykuku/luci-theme-argon"
    )

    for key in "${!CUSTOM_FEEDS[@]}"; do
        if ! grep -q "${CUSTOM_FEEDS[$key]}" "$FEED_CONF"; then
            echo "➕ 添加源: $key"
            echo "${CUSTOM_FEEDS[$key]}" >> "$FEED_CONF"
        else
            echo "⏩ 已存在: $key"
        fi
    done

    if ! grep -q "v2ray-geodata" "$FEED_CONF"; then
        echo "src-git v2raygeo https://github.com/sbwml/v2ray-geodata" >> "$FEED_CONF"
    fi
}

# 安装插件配置
function configure_plugins() {
    echo "⚙️ 生成插件配置..."
    local CONFIG_FILE=".config"
    
    # 基础配置
    cat <<EOF >> "$CONFIG_FILE"
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_libpam=y
CONFIG_PACKAGE_liblzma=y
CONFIG_PACKAGE_lm-sensors=y
CONFIG_LUCI_LANG_zh_Hans=y
EOF

    # 插件列表
    local PLUGINS=(
        "luci-app-fros"
        "luci-app-mosdns"
        "luci-app-alist"
        "luci-app-advanced"
        "luci-app-autotimeset"
        "luci-theme-argon"
        "v2ray-geodata"
    )

    for plugin in "${PLUGINS[@]}"; do
        echo "✅ 启用: $plugin"
        echo "CONFIG_PACKAGE_${plugin}=y" >> "$CONFIG_FILE"
    done

    # 关键合并步骤
    echo "🔄 合并默认配置..."
    cp .config .config.bak
    make defconfig
    cat .config.bak >> .config
    sort -u .config -o .config

    # 安装依赖
    echo "🔗 安装依赖项..."
    ./scripts/feeds install -a --force-overwrite
}

# 更新 feeds 增强版
function update_feeds() {
    echo "🔄 开始更新 feeds..."
    local MAX_RETRY=2
    
    for ((i=1; i<=MAX_RETRY; i++)); do
        echo "▶️ 第 $i 次尝试更新"
        if ./scripts/feeds update -a; then
            echo "✅ feeds 更新成功"
            break
        else
            echo "❌ feeds 更新失败"
            [ $i -eq MAX_RETRY ] && exit 1
            sleep 10
        fi
    done
    
    echo "📦 安装所有软件包"
    ./scripts/feeds install -a --force-overwrite
}

# 主流程
function main() {
    replace_golang
    clean_conflicts
    add_custom_feeds
    update_feeds
    configure_plugins
    
    echo "✅ 所有组件配置完成"
    echo "=== 最终 feeds 状态 ==="
    ./scripts/feeds list -r
    echo "=== 关键配置验证 ==="
    grep -E 'CONFIG_PACKAGE|CONFIG_LUCI' .config || true
}

main 2>&1 | tee diy-plug.log
