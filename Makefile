include $(TOPDIR)/rules.mk

PKG_NAME:=udp2raw
PKG_VERSION:=20190716
PKG_RELEASE:=3

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/wangyu-/udp2raw-tunnel.git
PKG_SOURCE_VERSION:=5cc304a26181ee17bc583b79a2e80449ea63e1b7
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)

PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/udp2raw
	SECTION:=net
	CATEGORY:=Network
	TITLE:=A tunnel which turns UDP traffic into encrypted traffic
	URL:=https://github.com/wangyu-/udp2raw-tunnel
endef

define Package/udp2raw/description
A tunnel which turns UDP traffic into encrypted UDP/FakeTCP/ICMP traffic by using raw socket,
helps you bypass UDP firewalls or unstable UDP Environment.
endef

define Build/Configure
	$(SED) 's/cc_cross=.*/cc_cross=$(TARGET_CXX)/g' $(PKG_BUILD_DIR)/makefile
	$(SED) 's/\\".*shell git rev-parse HEAD.*\\"/\\"$(PKG_SOURCE_VERSION)\\"/g' $(PKG_BUILD_DIR)/makefile
endef

MAKE_FLAGS += cross2

define Package/udp2raw/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/udp2raw_cross $(1)/usr/bin/udp2raw
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/udp2raw.init $(1)/etc/init.d/udp2raw
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) files/udp2raw.config $(1)/etc/config/udp2raw
endef

$(eval $(call BuildPackage,udp2raw))
