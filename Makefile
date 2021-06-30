export TARGET = iphone:latest:13.0
export ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = Preferences MobileSMS
include $(THEOS)/makefiles/common.mk

#SOURCES := $(wildcard Folder/*.m)

TWEAK_NAME = RealButtons
$(TWEAK_NAME)_GENERATOR = internal
# $(TWEAK_NAME)_FILES = $(wildcard *.xm)
$(TWEAK_NAME)_FILES = Tweak.xm OfferButton.xm
$(TWEAK_NAME)_CFLAGS += -fobjc-arc -Wno-deprecated-declarations
# $(TWEAK_NAME)_LIBRARIES = flex

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
