#!/bin/sh

# patch -p1 -d . < patch-for-iphone-ruby-1.8.7-p72

./configure --target=arm-apple-darwin11 \
	CC=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/cc \
	CPP=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/cpp \
	LD=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ld \
	AR=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ar \
	RANLIB=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ranlib \
	ac_cv_func_getpgrp_void=yes \
	ac_cv_func_setpgrp_void=yes \
	CFLAGS="-host -fmessage-length=0 -pipe -Wno-trigraphs -fpascal-strings -Os -mdynamic-no-pic \
 		-Wreturn-type -Wunused-variable -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk"
