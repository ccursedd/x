#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║            Starting All Bots Simultaneously               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Create logs directory
mkdir -p logs

# Kill any existing bot processes
pkill -f "binaries/bot_" 2>/dev/null
pkill -f "qemu-arm" 2>/dev/null
pkill -f "qemu-mips" 2>/dev/null

# Check if QEMU is installed for ARM/MIPS emulation
HAS_QEMU=false
if command -v qemu-arm-static &> /dev/null && command -v qemu-mips-static &> /dev/null; then
    HAS_QEMU=true
    echo "[✓] QEMU found - will emulate ARM and MIPS"
else
    echo "[!] QEMU not found - ARM/MIPS bots will be skipped"
    echo "    Install with: sudo apt install qemu-user-static binfmt-support"
fi
echo ""

# Start x86_64 bot (native)
echo "[1/3] Starting x86_64 bot (native)..."
./binaries/bot_x86_64 > logs/bot_x86_64.log 2>&1 &
PID1=$!
echo "  ✓ x86_64 bot running (PID: $PID1)"
echo ""

# Start ARM bot (emulated if needed)
echo "[2/3] Starting ARM bot..."
if [ "$HAS_QEMU" = true ]; then
    qemu-arm-static ./binaries/bot_arm > logs/bot_arm.log 2>&1 &
    PID2=$!
    echo "  ✓ ARM bot running with QEMU (PID: $PID2)"
else
    echo "  ✗ ARM bot skipped (QEMU not installed)"
    PID2="N/A"
fi
echo ""

# Start MIPS bot (emulated if needed)
echo "[3/3] Starting MIPS bot..."
if [ "$HAS_QEMU" = true ]; then
    qemu-mips-static ./binaries/bot_mips > logs/bot_mips.log 2>&1 &
    PID3=$!
    echo "  ✓ MIPS bot running with QEMU (PID: $PID3)"
else
    echo "  ✗ MIPS bot skipped (QEMU not installed)"
    PID3="N/A"
fi
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    All Bots Running!                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Status:"
echo "  • x86_64: PID $PID1"
echo "  • ARM:    PID $PID2"
echo "  • MIPS:   PID $PID3"
echo ""
echo "📝 Logs:"
echo "  • x86_64: tail -f logs/bot_x86_64.log"
echo "  • ARM:    tail -f logs/bot_arm.log"
echo "  • MIPS:   tail -f logs/bot_mips.log"
echo ""
echo "🔍 Monitor all logs: tail -f logs/*.log"
echo "🛑 Stop all bots:    pkill -f 'binaries/bot_'"
echo ""
echo "📊 Check connections: sudo netstat -tunap | grep 1337"
