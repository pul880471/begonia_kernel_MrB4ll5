#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
export USE_CCACHE=1
ccache -M 10G
export PATH="/home/ubuntu/clang/bin:$PATH"
export KBUILD_BUILD_USER="MrBalls"
export KBUILD_BUILD_HOST="begonia"

make O=out ARCH=arm64 begonia_user_defconfig
./scripts/config --file out/.config --disable CC_STACKPROTECTOR_STRONG
./scripts/config --file out/.config --enable CC_STACKPROTECTOR_NONE
./scripts/config --file out/.config --enable KSU
./scripts/config --file out/.config --disable LOCALVERSION_AUTO
make O=out ARCH=arm64 olddefconfig

make -j4 O=out \
    ARCH=arm64 \
    CC="ccache clang" \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    LLVM=1 \
    LLVM_IAS=1
