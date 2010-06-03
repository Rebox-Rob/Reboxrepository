#############################################################
#
# openssl
#
#############################################################
OPENSSL_VERSION:=0.9.8o
OPENSSL_SITE:=http://www.openssl.org/source
OPENSSL_INSTALL_STAGING = YES
OPENSSL_DEPENDENCIES = zlib

OPENSSL_TARGET_ARCH=generic32

# Some architectures are optimized in OpenSSL
ifeq ($(ARCH),ia64)
OPENSSL_TARGET_ARCH=ia64
endif
ifeq ($(ARCH),powerpc)
OPENSSL_TARGET_ARCH=ppc
endif
ifeq ($(ARCH),x86_64)
OPENSSL_TARGET_ARCH=x86_64
endif

define OPENSSL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure \
			linux-$(OPENSSL_TARGET_ARCH) \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			threads \
			shared \
			no-idea \
			no-rc5 \
			enable-camellia \
			enable-mdc2 \
			enable-tlsext \
			zlib-dynamic \
	)
	$(SED) "s:-march=[-a-z0-9] ::" -e "s:-mcpu=[-a-z0-9] ::g" $(@D)/Makefile
	$(SED) "s:-O[0-9]:$(TARGET_CFLAGS):" $(@D)/Makefile
endef

define OPENSSL_BUILD_CMDS
	$(MAKE1) CC=$(TARGET_CC) -C $(@D) all build-shared
	$(MAKE1) CC=$(TARGET_CC) -C $(@D) do_linux-shared
endef

define OPENSSL_INSTALL_STAGING_CMDS
	$(MAKE1) -C $(@D) INSTALL_PREFIX=$(STAGING_DIR) install
endef

define OPENSSL_INSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) INSTALL_PREFIX=$(TARGET_DIR) install
endef

define OPENSSL_REMOVE_DEV_FILES
	rm -rf $(TARGET_DIR)/usr/lib/ssl
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
OPENSSL_POST_INSTALL_TARGET_HOOKS += OPENSSL_REMOVE_DEV_FILES
endif

define OPENSSL_REMOVE_OPENSSL_BIN
	rm -f $(TARGET_DIR)/usr/bin/openssl
endef

ifneq ($(BR2_PACKAGE_OPENSSL_BIN),y)
OPENSSL_POST_INSTALL_TARGET_HOOKS += OPENSSL_REMOVE_OPENSSL_BIN
endif

define OPENSSL_INSTALL_FIXUPS
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
	# libraries gets installed read only, so strip fails
	chmod +w $(TARGET_DIR)/usr/lib/engines/lib*.so
	for i in $(addprefix $(TARGET_DIR)/usr/lib/,libcrypto.so.* libssl.so.*); \
	do chmod +w $$i; done
endef

OPENSSL_POST_INSTALL_TARGET_HOOKS += OPENSSL_INSTALL_FIXUPS

define OPENSSL_REMOVE_OPENSSL_ENGINES
	rm -rf $(TARGET_DIR)/usr/lib/engines
endef

ifneq ($(BR2_PACKAGE_OPENSSL_ENGINES),y)
OPENSSL_POST_INSTALL_TARGET_HOOKS += OPENSSL_REMOVE_OPENSSL_ENGINES
endif

define OPENSSL_UNINSTALL_CMDS
	rm -rf $(addprefix $(TARGET_DIR)/,etc/ssl usr/bin/openssl usr/include/openssl)
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/,ssl engines libcrypto* libssl* pkgconfig/libcrypto.pc)
	rm -rf $(addprefix $(STAGING_DIR)/,etc/ssl usr/bin/openssl usr/include/openssl)
	rm -rf $(addprefix $(STAGING_DIR)/usr/lib/,ssl engines libcrypto* libssl* pkgconfig/libcrypto.pc)
endef

$(eval $(call GENTARGETS,package,openssl))
