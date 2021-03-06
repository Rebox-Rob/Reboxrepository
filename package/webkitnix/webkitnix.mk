################################################################################
#
# webkitnix
#
################################################################################

WEBKITNIX_VERSION = 5e295afed5eb08ee7f313fa9233cff2b18d6f1de
WEBKITNIX_SITE = http://github.com/WebKitNix/webkitnix/tarball/master
WEBKITNIX_INSTALL_STAGING = YES
WEBKITNIX_DEPENDENCIES = host-pkgconf host-ruby host-flex host-bison host-gperf harfbuzz \
	icu jpeg libsoup libxml2 libxslt libglib2 cairo sqlite

WEBKITNIX_CONF_OPT += \
	-DPORT=Nix \
	-DWTF_USE_OPENGL_ES_2=ON \
	-DWTF_USE_CURL=OFF \
	-DENABLE_BATTERY_STATUS=OFF \
	-DENABLE_VIBRATION=OFF \
	-DENABLE_DRAG_SUPPORT=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_INPUT_SPEECH=OFF \
	-DENABLE_WEB_AUDIO=OFF \
	-DENABLE_TOOLS=OFF \
	-DENABLE_API_TESTS=OFF \
	-DDISABLE_STRICT_BUILD=ON

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WEBKITNIX_CONF_OPT += \
	-DCMAKE_C_FLAGS="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -DNDEBUG -DWTF_USE_VIDEOCORE_IV -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP" \
	-DCMAKE_CXX_FLAGS="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux -DNDEBUG -DWTF_USE_VIDEOCORE_IV -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP"
endif

#WEBKITNIX_MAKE_ENV += \
#	VERBOSE=1

$(eval $(cmake-package))
