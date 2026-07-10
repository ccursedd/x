#!/bin/bash

echo "Running multiple x86_64 instances..."

# Kill existing
pkill -f "binaries/bot" 2>/dev/null

# Copy binary multiple times and patch the arch string
for i in {1..3}; do
    cp binaries/bot_x86_64 binaries/bot_$i
    # This replaces "x86_64" with "bot$i" (not perfect but might work)
    sed -i "s/x86_64/bot$i/g" binaries/bot_$i
    ./binaries/bot_$i > logs/bot_$i.log 2>&1 &
    echo "  ✓ Instance $i (PID: $!)"
done

echo ""
echo "Checking connections..."
sleep 3
sudo netstat -tunap | grep 1337 | grep ESTABLISHED
