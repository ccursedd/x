#!/bin/bash

echo "Starting multiple bots without code changes..."

# Kill existing bots
pkill -f "binaries/bot" 2>/dev/null
pkill -f "qemu" 2>/dev/null

# Create logs directory
mkdir -p logs

# 1. Run x86_64 native
echo "  ✓ Starting x86_64..."
./binaries/bot_x86_64 > logs/x86_64.log 2>&1 &

# 2. Run ARM (emulated)
echo "  ✓ Starting ARM (emulated)..."
if command -v qemu-arm-static &> /dev/null; then
    qemu-arm-static ./binaries/bot_arm > logs/arm.log 2>&1 &
else
    echo "    ⚠ QEMU not found, skipping ARM"
fi

# 3. Run MIPS (emulated)
echo "  ✓ Starting MIPS (emulated)..."
if command -v qemu-mips-static &> /dev/null; then
    qemu-mips-static ./binaries/bot_mips > logs/mips.log 2>&1 &
else
    echo "    ⚠ QEMU not found, skipping MIPS"
fi

echo ""
echo "All available bots started!"
sleep 3
echo ""
echo "Connections to C2:"
sudo netstat -tunap | grep 1337 | grep ESTABLISHED
echo ""
echo "Logs: tail -f logs/*.log"
