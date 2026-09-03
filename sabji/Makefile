TARGET = iphone:clang:14.5:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PubGESP

PubGESP_FILES = Tweak.xm OverlayView.mm ESPManager.mm MemoryUtils.mm
PubGESP_CFLAGS = -fobjc-arc -std=c++17
PubGESP_LDFLAGS = -framework UIKit -framework CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk