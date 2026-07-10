#!/usr/bin/env python3

with open('main.py', 'r') as f:
    content = f.read()

# Replace _bot_loop with a version that doesn't close on recv(0)
new_loop = '''    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            client.settimeout(60)
            while True:
                try:
                    data = client.recv(1024)
                    if not data:
                        # recv(0) means the connection is still alive but no data
                        # Just continue and keep the connection open
                        time.sleep(1)
                        continue
                    print(f"[DEBUG] Received {len(data)} bytes from {username}")
                except socket.timeout:
                    # Send keep-alive PING
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

# Find and replace the existing _bot_loop
import re
pattern = r'    def _bot_loop\(self, client, username\):.*?(?=    def _ping_bots_loop)'
content = re.sub(pattern, new_loop, content, flags=re.DOTALL)

with open('main.py', 'w') as f:
    f.write(content)

print("✅ _bot_loop updated to keep connection alive!")
