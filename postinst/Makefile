TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = postinst

postinst_FILES = main.m
postinst_CFLAGS = -fobjc-arc
postinst_CODESIGN_FLAGS = -Sentitlements.plist
postinst_INSTALL_PATH = /DEBIAN
postinst_PRIVATE_FRAMEWORKS = CoreServices

include $(THEOS_MAKE_PATH)/tool.mk
