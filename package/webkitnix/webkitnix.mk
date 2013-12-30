################################################################################
#
# webkitnix
#
################################################################################

WEBKITNIX_VERSION = acb1e2167def0f485540487fd44aad41dbc24b67
WEBKITNIX_SITE = http://github.com/WebKitNix/webkitnix/tarball/master
WEBKITNIX_INSTALL_STAGING = YES
WEBKITNIX_DEPENDENCIES = host-pkgconf host-ruby host-flex host-bison host-gperf harfbuzz \
	icu jpeg libcurl libsoup libxml2 libxslt libglib2 cairo sqlite

WEBKITNIX_CONF_OPT += \
	-DPORT=Nix \
	-DWTF_USE_OPENGL_ES_2=ON \
	-DWTF_USE_CURL=ON \
	-DENABLE_BATTERY_STATUS=OFF \
	-DENABLE_VIBRATION=OFF \
	-DENABLE_DRAG_SUPPORT=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_INPUT_SPEECH=OFF \
	-DENABLE_SVG=OFF \
	-DDISABLE_STRICT_BUILD=ON

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WEBKITNIX_CONF_OPT += \
	-DCMAKE_C_FLAGS="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -DNDEBUG=1" \
	-DCMAKE_CXX_FLAGS="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -DNDEBUG=1"
endif

#WEBKITNIX_MAKE_ENV += \
#	VERBOSE=1

$(eval $(cmake-package))