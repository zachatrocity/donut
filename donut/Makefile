ARCHS = armv7 arm64 
include theos/makefiles/common.mk

BUNDLE_NAME = donut
donut_FILES = donut.mm
donut_INSTALL_PATH = /Library/PreferenceBundles
donut_FRAMEWORKS = UIKit
donut_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/donut.plist$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Donut$(ECHO_END)
	$(ECHO_NOTHING)cp donutdrawer.png $(THEOS_STAGING_DIR)/Library/Donut/donutdrawer.png$(ECHO_END)
