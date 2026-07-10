#!/usr/bin/env python3

with open('main.py', 'r') as f:
    content = f.read()

# Replace _bot_loop with a version that handles bot communication
old_loop = '''    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            while True:
                client.settimeout(60)
                try:
                    data = client.recv(1024)
                    if not data:
                        break
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
                pass'''

new_loop = '''    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            # Set a timeout for recv
            client.settimeout(30)
            while True:
                try:
                    # Try to receive data from bot
                    data = client.recv(1024)
                    if not data:
                        print(f"[DEBUG] Bot {username} sent no data, removing")
                        break
                    # If we get data, the bot is alive
                    print(f"[DEBUG] Received {len(data)} bytes from {username}")
                except socket.timeout:
                    # No data received, but connection is still alive
                    # Send a PING to keep the bot alive
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

content = content.replace(old_loop, new_loop)

with open('main.py', 'w') as f:
    f.write(content)

print("✅ _bot_loop updated!")
