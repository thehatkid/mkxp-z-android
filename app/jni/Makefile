NDK       := ${ANDROID_NDK_HOME}
TOOLCHAIN := $(NDK)/toolchains/llvm/prebuilt/${ARCH}
NPROC     := $(shell nproc)

# Android platform API version to build:
# (Default: 21 - Android 5.0 Lollipop)
# See https://apilevels.com/ for Android API versions.
# Note: If you building for 64-bit, you should target 21 and higher.
API ?= 21

# Android CPU specific variables to build:
# (Default: ARMv7-A 32-bit)
# For ARMv7-A 32-bit:
# - HOST:   armv7a-linux-androideabi
# - TARGET: arm-linux-androideabi
# - ABI:    armeabi-v7a
# For ARMv8-A 64-bit:
# - HOST:   aarch64-linux-android
# - TARGET: aarch64-linux-android
# - ABI:    arm64-v8a
# For x86 32-bit:
# - HOST:   i686-linux-android
# - TARGET: i686-linux-android
# - ABI:    x86
# For x86_64 64-bit:
# - HOST:   x86_64-linux-android
# - TARGET: x86_64-linux-android
# - ABI:    x86_64
HOST   ?= armv7a-linux-androideabi
TARGET ?= arm-linux-androideabi
ABI    ?= armeabi-v7a

# Define directories
PREFIX            := $(HOST)$(API)
BUILD_PREFIX      := ${PWD}/build-$(ABI)
INCDIR            := $(BUILD_PREFIX)/include
LIBDIR            := $(BUILD_PREFIX)/lib
PKG_CONFIG_LIBDIR := $(BUILD_PREFIX)/lib/pkgconfig

ifneq (, ${MSYSTEM})
	RUBY_PREFIX := $(shell cygpath -m ${BUILD_PREFIX})
else ifneq (, $(findstring /cygdrive/,$(PATH)))
	RUBY_PREFIX := $(shell cygpath -m ${BUILD_PREFIX})
else
	RUBY_PREFIX := $(BUILD_PREFIX)
endif

# Toolchain tools
CC      := $(TOOLCHAIN)/bin/$(PREFIX)-clang
CXX     := $(TOOLCHAIN)/bin/$(PREFIX)-clang++
AS      := $(TOOLCHAIN)/bin/llvm-as
LD      := $(TOOLCHAIN)/bin/ld
AR      := $(TOOLCHAIN)/bin/llvm-ar
NM      := $(TOOLCHAIN)/bin/llvm-nm
OBJCOPY := $(TOOLCHAIN)/bin/llvm-objcopy
OBJDUMP := $(TOOLCHAIN)/bin/llvm-objdump
RANLIB  := $(TOOLCHAIN)/bin/llvm-ranlib
STRIP   := $(TOOLCHAIN)/bin/llvm-strip

# OpenSSL configure has own targets for Android building
ifeq ($(ABI), armeabi-v7a)
	OPENSSL_TARGET := android-arm
else ifeq ($(ABI), arm64-v8a)
	OPENSSL_TARGET := android-arm64
else ifeq ($(ABI), x86)
	OPENSSL_TARGET := android-x86
else ifeq ($(ABI), x86_64)
	OPENSSL_TARGET := android-x86_64
endif

# Some flags for ARM arch
ifeq ($(ABI), armeabi-v7a)
	CROSSFLAGS := -D__ARM_ARCH_7A__ -D__arm__ -march=armv7-a -mtune=cortex-a7 -mfpu=neon -mfloat-abi=softfp
else ifeq ($(ABI), arm64-v8a)
	CROSSFLAGS := -D__ARM_ARCH_8A__ -D__aarch64__ -march=armv8-a -mtune=cortex-a53
endif

# Compiler/linker flags
CFLAGS      := -O0 $(CROSSFLAGS) --sysroot=$(TOOLCHAIN)/sysroot -I$(TOOLCHAIN)/sysroot/usr/include -I$(INCDIR)
LDFLAGS     := -L$(LIBDIR) -lm -lz
CLANG_FLAGS := -target $(TARGET) --gcc-toolchain $(TOOLCHAIN)

# CMake arguments
CMAKE_ARGS := \
	-DCMAKE_TOOLCHAIN_FILE="$(NDK)/build/cmake/android.toolchain.cmake" \
	-DCMAKE_SYSTEM_NAME=Android \
	-DCMAKE_SYSTEM_VERSION=$(API) \
	-DANDROID_PLATFORM=$(API) \
	-DANDROID_ABI=$(ABI) \
	-DCMAKE_ANDROID_ARCH_ABI=$(ABI) \
	-DCMAKE_ANDROID_STL_TYPE=c++_shared \
	-DCMAKE_INSTALL_PREFIX="$(BUILD_PREFIX)" \
	-DCMAKE_PREFIX_PATH="$(BUILD_PREFIX)" \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_C_FLAGS="$(CFLAGS)" \
	-G "Unix Makefiles"

# Autoconf environment variables
CONFIGURE_ENV := \
	CC="$(CC)" CXX="$(CXX)" AS="$(AS)" LD="$(LD)" AR="$(AR)" NM="$(NM)" \
	RANLIB="$(RANLIB)" STRIP="$(STRIP)" OBJCOPY="$(OBJCOPY)" OBJDUMP="$(OBJDUMP)" \
	CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" CLANG_FLAGS="$(CLANG_FLAGS)" \
	PKG_CONFIG_LIBDIR="$(PKG_CONFIG_LIBDIR)"

# Autoconf arguments
CONFIGURE_ARGS := --host=$(HOST) --prefix="$(BUILD_PREFIX)"

# Only Android 8.0 Oreo and higher can have some POSIX functions like:
# getpwent(), setpwent(), endpwent(), nl_langinfo(), and nl_langinfo_l()
ifeq ($(shell test $(API) -ge 26; echo $$?), 1)
	CONFIGURE_ARGS += ac_cv_header_pwd_h=no ac_cv_header_langinfo_h=no
endif

# OpenAL CMake arguments to build
OPENAL_CONFIGURE_ARGS := \
	-DALSOFT_REQUIRE_OPENSL=ON \
	-DALSOFT_EXAMPLES=OFF \
	-DALSOFT_UTILS=OFF

# Ruby configure arguments to build
RUBY_CONFIGURE_ARGS := \
	--prefix="$(RUBY_PREFIX)" \
	--enable-shared \
	--enable-static \
	--enable-install-static-library \
	--disable-install-doc \
	--disable-rubygems \
	--with-static-linked-ext \
	--with-out-ext=readline,dbm,gdbm,win32,win32ole,fiddle \
	--without-gmp

CONFIGURE := $(CONFIGURE_ENV) ./configure $(CONFIGURE_ARGS)
CMAKE     := $(CONFIGURE_ENV) cmake .. $(CMAKE_ARGS)


.PHONY: all init clean cpufeatures pixman iconv openal openssl ruby clean-pixman clean-iconv clean-openal clean-openssl clean-ruby

default: all


# -------------------- Android CPU features --------------------
cpufeatures: init $(LIBDIR)/libcpufeatures.a

$(LIBDIR)/libcpufeatures.a: $(LIBDIR)/cpu-features.o
	$(AR) rc $(LIBDIR)/libcpufeatures.a $(LIBDIR)/cpu-features.o

$(LIBDIR)/cpu-features.o:
	$(CC) -c $(NDK)/sources/android/cpufeatures/cpu-features.c -o $(LIBDIR)/cpu-features.o -Wall -Wextra -Werror

# -------------------- Pixman --------------------
pixman: init cpufeatures $(LIBDIR)/libpixman-1.a

$(LIBDIR)/libpixman-1.a: pixman/Makefile
	cd pixman; make -j$(NPROC); make install

pixman/Makefile: pixman/configure
	cd pixman; $(CONFIGURE_ENV) \
	CFLAGS="$(CFLAGS) -fno-integrated-as -I$(NDK)/sources/android/cpufeatures" \
	LDFLAGS="$(LDFLAGS) -lcpufeatures" \
	./configure $(CONFIGURE_ARGS) --enable-static=true --enable-shared=false

pixman/configure: pixman/configure.ac
	cd pixman; autoreconf -i

# -------------------- iconv --------------------
iconv: init $(LIBDIR)/libiconv.a

$(LIBDIR)/libiconv.a: libiconv/Makefile
	cd libiconv; make -j$(NPROC); make install

libiconv/Makefile: libiconv/configure
	cd libiconv; $(CONFIGURE) --enable-static=true --enable-shared=false

# -------------------- OpenAL --------------------
openal: init $(LIBDIR)/libopenal.so

$(LIBDIR)/libopenal.so: openal/cmakebuild/Makefile
	cd openal/cmakebuild; make -j$(NPROC); make install

openal/cmakebuild/Makefile: openal/CMakeLists.txt
	cd openal; mkdir cmakebuild; cd cmakebuild; \
	$(CMAKE) -DLIBTYPE=SHARED $(OPENAL_CONFIGURE_ARGS)

# -------------------- OpenSSL --------------------
openssl: init $(LIBDIR)/libssl.a

$(LIBDIR)/libssl.a: openssl/Makefile
	cd openssl; make -j$(NPROC); make install_sw

openssl/Makefile: openssl/Configure
	cd openssl; CFLAGS="-Wno-macro-redefined" ./Configure $(OPENSSL_TARGET) \
	no-shared -D__ANDROID_API__=$(API) \
	--prefix="$(BUILD_PREFIX)" --openssldir="$(BUILD_PREFIX)"

# -------------------- Ruby --------------------
ruby: init openssl $(LIBDIR)/libruby.so.3.1.0

$(LIBDIR)/libruby.so.3.1.0: ruby/Makefile
	cd ruby; make -j$(NPROC); make install

ruby/Makefile: ruby/configure
	cd ruby; DLDFLAGS="-Wl,-soname,libruby.so" \
	$(CONFIGURE) $(RUBY_CONFIGURE_ARGS)

ruby/configure: ruby/configure.ac
	cd ruby; autoreconf -i


init:
	@mkdir -p $(LIBDIR) $(INCDIR)

clean-pixman:
	-cd pixman; make clean; rm Makefile; rm configure

clean-iconv:
	-cd libiconv; make clean; rm Makefile

clean-openal:
	-cd openal; rm -rf cmakebuild

clean-openssl:
	-cd openssl; make clean; rm Makefile

clean-ruby:
	-cd ruby; make clean; rm Makefile; rm configure

clean: clean-pixman clean-iconv clean-openal clean-openssl clean-ruby

all: pixman iconv openal openssl ruby
