DEPENDS_PACKAGES="
	PACKAGE_luci
	PACKAGE_luci-base
	LUCI_LANG_zh_Hans
	PACKAGE_luci-compat
	PACKAGE_wget-ssl
	PACKAGE_curl
	PACKAGE_openssl-util
	PACKAGE_luci-app-zerotier
	PACKAGE_iptables-nft 
	PACKAGE_tc-tiny
	PACKAGE_iptables-mod-iprange
	PACKAGE_tc-mod-iptables
	PACKAGE_kmod-sched-core
	PACKAGE_iptables-zz-legacy
	PACKAGE_fros
	PACKAGE_fros_files
	PACKAGE_luci-app-fros 
"
init_depend_package_config()
{
	sed -i "/CONFIG_PACKAGE_firewall4/d" .config
        echo 'CONFIG_PACKAGE_firewall4=n' >>.config
	for package in $DEPENDS_PACKAGES;do
		echo "add depend package CONFIG_PACKAGE_$package"
		sed -i "/CONFIG_$package/d" .config
		echo "CONFIG_$package=y" >>.config
	done
	make defconfig
}
