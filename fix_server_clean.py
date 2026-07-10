#!/usr/bin/env python3

with open('main.py', 'r') as f:
    content = f.read()

# Add _bot_loop method before _ping_bots_loop
bot_loop = '''    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            print(f"[DEBUG] _bot_loop started for {username}")
            client.settimeout(60)
            while True:
                try:
                    data = client.recv(1024)
                    if not data:
                        time.sleep(1)
                        continue
                except socket.timeout:
                    try:
                        client.send(b"PING\\n")
                        print(f"[DEBUG] Sent PING to {username}")
                    except:
                        break
                    continue
                except Exception as e:
                    print(f"[DEBUG] Error: {e}")
                    break
        except Exception as e:
            print(f"[DEBUG] Outer error: {e}")
        finally:
            self.bot_manager.remove(client)
            try:
                client.close()
            except:
                pass
'''
content = content.replace('    def _ping_bots_loop(self):', bot_loop + '\n    def _ping_bots_loop(self):')

# Fix bot authentication
old_auth = '''if verify_bot_auth(password, username, self.bot_secret):
                self.bot_manager.register(client, address, username)
                return'''
new_auth = '''if verify_bot_auth(password, username, self.bot_secret):
                self.bot_manager.register(client, address, username)
                print(f"[DEBUG] Registered bot: {username}")
                threading.Thread(target=self._bot_loop, args=(client, username), daemon=True).start()
                return'''
content = content.replace(old_auth, new_auth)

with open('main.py', 'w') as f:
    f.write(content)

print("✅ Server fixed cleanly!")
