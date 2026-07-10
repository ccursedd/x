#!/bin/bash

mkdir -p binaries

declare -A compilers=(
    ["armv4l"]="arm-linux-gnueabi-gcc"
    ["armv5l"]="arm-linux-gnueabi-gcc"
    ["armv6l"]="arm-linux-gnueabi-gcc"
    ["armv7l"]="arm-linux-gnueabihf-gcc"
    ["i486"]="gcc -m32"
    ["i586"]="gcc -m32"
    ["i686"]="i686-linux-gnu-gcc"
    ["x86_64"]="gcc"
    ["mips"]="mips-linux-gnu-gcc"
    ["mipsel"]="mipsel-linux-gnu-gcc"
    ["powerpc"]="powerpc-linux-gnu-gcc"
    ["sparc"]="sparc64-linux-gnu-gcc"
)

echo "[*] Building bot for all architectures..."
echo "========================================"

for arch in "${!compilers[@]}"; do
    compiler="${compilers[$arch]}"
    output="binaries/bot_${arch}"
    
    echo -n "[*] Building $arch... "
    
    # Try dynamic linking first (no -static)
    if $compiler -o "$output" bot/*.c -Wall -O2 2>/dev/null; then
        echo "✅ SUCCESS"
    else
        # Try static if dynamic fails
        if $compiler -o "$output" bot/*.c -Wall -O2 -static 2>/dev/null; then
            echo "✅ SUCCESS (static)"
        else
            echo "❌ FAILED"
        fi
    fi
done

echo "========================================"
echo "[*] Built binaries:"
ls -lh binaries/bot_* 2>/dev/null | grep -v test
