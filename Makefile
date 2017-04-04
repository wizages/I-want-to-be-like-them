include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IWantToBeLikeThem
IWantToBeLikeThem_FILES = Tweak.xm LetsTakePicturesViewController.m $(wildcard LLSimpleCamera/*m)

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = BeLikeThem
BeLikeThem_INSTALL_PATH = /Library/Application Support/

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
