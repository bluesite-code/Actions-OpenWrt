#!/bin/bash
# 增强版自定义脚本，带错误处理和依赖管理

set -eo pipefail  # 增强错误检测

# Golang 源替换（带增强验证）
function replace_golang() {
    echo "🔄 开始替换 Golang 源..."
    local REPO_URL="https://github.com/sbwml/packages_lang_golang"
    local BRANCH="23.x"
    local TARGET_DIR="feeds/packages/lang/golang"
    local MAX_RETRY=3

    echo "🗑️ 清理旧组件..."
    rm -rf "$TARGET_DIR"
    mkdir -vp "$TARGET_DIR"

    # 带重试的克隆函数
    for ((i=1; i<=MAX_RETRY; i++)); do
        echo "🔄 克隆尝试第 $i 次 ($BRANCH)"
        if git clone --depth 1 -b "$BRANCH" "$REPO_URL" "$TARGET_DIR"; then
            echo "✅ 克隆成功"
            break
        fi
        echo "❌ 克隆失败，5秒后重试..."
        sleep 5
        rm -rf "$TARGET_DIR"
        [ $i -eq $MAX_RETRY ] && { echo "::error::克隆失败！"; exit 1; }
    done

    # 关键文件验证
    local CRITICAL_FILES=(
        "golang-version.mk"
        "golang-package.mk"
    )
    for file in "${CRITICAL_FILES[@]}"; do
        if [ ! -f "$TARGET_DIR/$file" ]; then
            echo "::error::关键文件缺失: $file"
            ls -l "$TARGET_DIR"
            exit 1
        fi
    done
}

# 安装插件
function install_plugins() {
    echo "📦 安装插件组件..."
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
        if ! git clone --depth 1 "${args[@]}" ; then
            echo "::warning::克隆失败: ${args[0]}"
            continue
        fi
    done
}

# 更新 feeds
function update_feeds() {
    echo "🔄 更新 feeds 缓存..."
    ./scripts/feeds update -a -f
    ./scripts/feeds install -a -f --force-overwrite
}

# 主执行流程
main() {
    add_feeds
    replace_golang    # 必须在其他插件前执行
    echo "=== 当前工作目录 ==="
pwd
echo "=== 目录结构预览 ==="
tree -L 3 feeds/packages/lang || ls -lR feeds/packages/lang
    install_plugins
    update_feeds      # 最后统一更新

    echo "✅ 所有组件配置完成"
    echo "=== 最终 feeds 列表 ==="
    ./scripts/feeds list -i
}

# 执行主函数并记录日志
main 2>&1 | tee diy-plug.log
