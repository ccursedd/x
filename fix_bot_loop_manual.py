#!/usr/bin/env python3

with open('main.py', 'r') as f:
    content = f.read()

# Find the _bot_loop function and replace it
new_loop = '''    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            client.settimeout(60)
            while True:
                try:
                    data = client.recv(1024)
                    if not data:
                        # Connection still alive, just continue
                        time.sleep(1)
                        continue
                    print(f"[DEBUG] Received {len(data)} bytes from {username}")
                except socket.timeout:
                    try:
                        client.send(b"PING\\n")
                        print(f"[DEBUG] Sent PING to {username}")
                    except:
                        print(f"[DEBUG] Failed to send PING to {username}")
                        break
                except Exception as e:
                    print(f"[DEBUG] Error in _bot_loop: {e}")
                    break
        except:
            pass
        finally:
            self.bot_manager.remove(client)
            print(f"[DEBUG] Bot {username} removed")
            try:
                client.close()
            except:
                pass'''

# Replace the _bot_loop function
import re
pattern = r'    def _bot_loop\(self, client, username\):.*?(?=    def _ping_bots_loop)'
content = re.sub(pattern, new_loop, content, flags=re.DOTALL)

with open('main.py', 'w') as f:
    f.write(content)

print("✅ _bot_loop fixed!")
