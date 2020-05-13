include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-filerun
PKG_VERSION:=2.0
PKG_RELEASE:=20200514

PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_SOURCE_URL:=http://www.filerun.com/download-latest
UNTAR_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME)-extract
PKG_HASH:=skip
PKG_MAINTAINER:=GaryPang <https://github.com/garypang13/luci-app-filerun>

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-filerun
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI for filerun
	PKGARCH:=all
	DEPENDS:=+luci-ssl-nginx +php7 +php7-fpm +php7-mod-curl +php7-mod-gd +php7-mod-iconv +php7-mod-json +php7-mod-mbstring +php7-mod-opcache +php7-mod-session +php7-mod-zip +php7-mod-sqlite3 +php7-mod-openssl
endef

define Package/luci-app-filerun/extra_provides
    echo 'libstdc++.so.6'; \
    echo 'libpthread.so.0'; \
    echo 'libm.so.6'; \
    echo 'libc.so.6';
endef

define Build/Prepare
	mkdir -vp $(UNTAR_DIR)
	tar -zxvf $(DL_DIR)/$(PKG_SOURCE) -C $(UNTAR_DIR)
endef

define Build/Compile
endef

define Package/luci-app-filerun/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	if [ -d "./luasrc" ]; then \
		cp -pR ./luasrc/* $(1)/usr/lib/lua/luci/; \
	fi
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	
	$(INSTALL_DIR) $(1)/www/filerun
	$(CP) \
		$(UNTAR_DIR)/$(PKG_SOURCE_SUBDIR)/{a,cron,css,customizables,images,js,logout,oauth2,ocs,oembed,panel,sounds,sso,system,weblinks,wl} \
		$(UNTAR_DIR)/$(PKG_SOURCE_SUBDIR)/{index.php,dav.php,favicon.ico,guest.php,index.php,initial_version.txt,recommended.web.config,remote.php,status.php,t.php} \
		$(1)/www/filerun
endef

$(eval $(call BuildPackage,luci-app-filerun))
