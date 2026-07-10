#!/bin/bash
# This is a simplified version of build_all.sh using system compilers

# Define compilers mapping
declare -A compilers=(
    ["armv4l"]="arm-linux-gnueabi-gcc"
    ["armv5l"]="arm-linux-gnueabi-gcc"
    ["armv6l"]="arm-linux-gnueabi-gcc"
    ["armv7l"]="arm-linux-gnueabihf-gcc"
    ["i486"]="gcc -m32"
    ["i586"]="gcc -m32"
    ["i686"]="gcc -m32"
    ["x86_64"]="gcc"
    ["mips"]="mips-linux-gnu-gcc"
    ["mipsel"]="mipsel-linux-gnu-gcc"
    ["powerpc"]="powerpc-linux-gnu-gcc"
    ["sparc"]="sparc64-linux-gnu-gcc"
)

# Build for each architecture
for arch in "${!compilers[@]}"; do
    compiler="${compilers[$arch]}"
    echo "Building for $arch with $compiler..."
    $compiler -o "binaries/bot_$arch" bot/*.c -Wall -O2 -static 2>&1 | head -5
done
