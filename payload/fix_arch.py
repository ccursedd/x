#!/usr/bin/env python3

with open('bot/bot.c', 'r') as f:
    content = f.read()

# Find and replace the get_architecture function
old_func = '''char *get_architecture() {
    static char arch[64];
    FILE *fp;

    fp = popen("uname -m", "r");
    if (fp == NULL) {
        strcpy(arch, "unknown");
    } else {
        if (fgets(arch, sizeof(arch) - 1, fp) != NULL) {
            arch[strcspn(arch, "\\n")] = 0;
        } else {
            strcpy(arch, "unknown");
        }
        pclose(fp);
    }

    return arch;
}'''

new_func = '''char *get_architecture() {
    static char arch[64];
    snprintf(arch, sizeof(arch), "%s", ARCH_NAME);
    return arch;
}'''

content = content.replace(old_func, new_func)

with open('bot/bot.c', 'w') as f:
    f.write(content)

print("✅ get_architecture() function fixed!")
