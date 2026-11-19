#!/usr/bin/env bash
set -euo pipefail

KERNEL_DIR="/home/ubuntu/kernel_begonia/kernel_gpu_oc"
CLANG_DIR="/home/ubuntu/clang"
OUT_DIR="$KERNEL_DIR/out"
DEFCONFIG="begonia_user_defconfig"

export PATH="$CLANG_DIR/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64

cd "$KERNEL_DIR"
mkdir -p "$OUT_DIR"

make -j4 O="$OUT_DIR" \
    ARCH=arm64 \
    CC="ccache clang" \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    LLVM=1 \
    LLVM_IAS=1 \
    HOSTCFLAGS="-fcommon" \
    "$DEFCONFIG"

make -j4 O="$OUT_DIR" \
    ARCH=arm64 \
    CC="ccache clang" \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    LLVM=1 \
    LLVM_IAS=1 \
    HOSTCFLAGS="-fcommon"

IMAGE_GZ_DTB="$OUT_DIR/arch/arm64/boot/Image.gz-dtb"
test -f "$IMAGE_GZ_DTB"
ls -lh "$IMAGE_GZ_DTB"
