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

echo "[*] Building bot (with debug output)..."
echo "========================================"

for arch in "${!compilers[@]}"; do
    compiler="${compilers[$arch]}"
    output="binaries/bot_${arch}"
    
    echo ""
    echo "[*] Building $arch with $compiler..."
    echo "----------------------------------------"
    
    # Show the actual error messages
    $compiler -o "$output" bot/*.c -Wall -O2 -static 2>&1 | head -20
    
    if [ -f "$output" ]; then
        echo "✅ SUCCESS: $output"
    else
        echo "❌ FAILED: $arch"
    fi
done
