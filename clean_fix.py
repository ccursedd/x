#!/usr/bin/env python3
import re

with open('main.py', 'r') as f:
    content = f.read()

# 1. Add _bot_loop method
bot_loop = '''    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            client.settimeout(60)
            while True:
                try:
                    data = client.recv(1024)
                    if not data:
                        continue
                except socket.timeout:
                    try:
                        client.send(b"PING\\n")
                    except:
                        break
                    continue
                except:
                    break
        except:
            pass
        finally:
            self.bot_manager.remove(client)
            try:
                client.close()
            except:
                pass
'''
content = content.replace('    def _ping_bots_loop(self):', bot_loop + '\n    def _ping_bots_loop(self):')

# 2. Fix authentication section
auth_pattern = r'if verify_bot_auth\(password, username, self\.bot_secret\):\n\s+self\.bot_manager\.register\(client, address, username\)\n\s+return'
auth_replacement = '''if verify_bot_auth(password, username, self.bot_secret):
                self.bot_manager.register(client, address, username)
                threading.Thread(target=self._bot_loop, args=(client, username), daemon=True).start()
                return'''
content = re.sub(auth_pattern, auth_replacement, content)

with open('main.py', 'w') as f:
    f.write(content)

print("✅ Fixed!")
