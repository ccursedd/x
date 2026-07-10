#!/bin/bash

# Function to build with specific ARCH_NAME
build_with_arch() {
    local arch_name="$1"
    local output="$2"
    local compiler="$3"
    local flags="$4"
    
    echo "Building $arch_name -> $output"
    # Temporarily change ARCH_NAME in config.h
    sed -i "s/#define ARCH_NAME .*/#define ARCH_NAME \"$arch_name\"/" bot/config.h
    $compiler $flags -o "$output" bot/*.c -Wall -O2
}

# Build each architecture with unique name
build_with_arch "x86_64" "binaries/bot_x86_64" "gcc" ""
build_with_arch "i686" "binaries/bot_i686" "i686-linux-gnu-gcc" ""
build_with_arch "i486" "binaries/bot_i486" "gcc" "-m32"
build_with_arch "i586" "binaries/bot_i586" "gcc" "-m32"
build_with_arch "armv7l" "binaries/bot_armv7l" "arm-linux-gnueabihf-gcc" ""
build_with_arch "armv6l" "binaries/bot_armv6l" "arm-linux-gnueabi-gcc" ""
build_with_arch "armv5l" "binaries/bot_armv5l" "arm-linux-gnueabi-gcc" ""
build_with_arch "armv4l" "binaries/bot_armv4l" "arm-linux-gnueabi-gcc" ""
build_with_arch "mips" "binaries/bot_mips" "mips-linux-gnu-gcc" ""
build_with_arch "mipsel" "binaries/bot_mipsel" "mipsel-linux-gnu-gcc" ""
build_with_arch "powerpc" "binaries/bot_powerpc" "powerpc-linux-gnu-gcc" ""
build_with_arch "sparc" "binaries/bot_sparc" "sparc64-linux-gnu-gcc" ""

echo "Done! All binaries have unique ARCH_NAME values."
