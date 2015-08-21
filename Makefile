export THEOS_DEVICE_IP=192.168.0.101
export ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk
export GO_EASY_ON_ME := 1

TWEAK_NAME = Donut
Donut_FILES = Tweak.xm
Donut_FRAMEWORKS = UIKit CoreGraphics Foundation QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
	
SUBPROJECTS += donut
include $(THEOS_MAKE_PATH)/aggregate.mk
