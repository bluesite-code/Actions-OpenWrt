#!/bin/bash
# 增强版 ImmortalWrt 定制脚本

set -euo pipefail  # 启用严格错误检查

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

    # 带重试的克隆过程
    for ((i=1; i<=MAX_RETRY; i++)); do
        echo "🔄 克隆尝试第 $i 次 ($BRANCH)"
        if git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$TARGET_DIR"; then
            echo "✅ 克隆成功"
            
            # 层级验证
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

    # 关键文件验证
    local CRITICAL_FILES=(
        "$TARGET_DIR/golang-version.mk"
        "$TARGET_DIR/golang-package.mk"
    )
    for file in "${CRITICAL_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            echo "::error::关键文件缺失: $file"
            echo "=== 详细目录结构 ==="
            tree -L 5 feeds/packages/lang
            exit 1
        else
            echo "✅ 验证通过: $file"
        fi
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

# 安装插件
function install_plugins() {
    echo "📦 开始安装插件..."
    local PLUGINS=(
        "https://github.com/bluesite-code/fros -b fros-23.05 package/fros"
        "https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns"
        "https://github.com/sbwml/v2ray-geodata package/v2ray-geodata"
        "https://github.com/sbwml/luci-app-alist package/alist"
        "https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced"
        "https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset"
        "https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon"
    )

    for repo in "${PLUGINS[@]}"; do
        local args=($repo)
        echo "🔧 克隆 ${args[0]}"
        if ! git clone --depth 1 "${args[@]}"; then
            echo "::warning::克隆失败: ${args[0]}"
            continue
        fi
    done
# 更新 feeds
function update_feeds() {
    echo "🔄 更新 feeds..."
    ./scripts/feeds update -a
    ./scripts/feeds install -a
}

# 主流程
main() {
    replace_golang    # 必须先执行
    clean_conflicts   # 在安装前清理
    install_plugins
    update_feeds
    
    echo "✅ 所有组件配置完成"
    echo "=== 最终目录结构验证 ==="
    tree -L 3 feeds/packages/lang || ls -lR feeds/packages/lang
    echo "=== 冲突文件终检 ==="
    ! find . -type f \( -name "*mosdns*" -o -name "*v2ray-geodata*" \) | grep .
}

# 执行并记录日志
main 2>&1 | tee diy-plug.log
