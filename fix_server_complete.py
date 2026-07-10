#!/usr/bin/env python3

with open('main.py', 'r') as f:
    content = f.read()

# Add _bot_loop before _ping_bots_loop
if '_bot_loop' not in content:
    bot_loop = '''
    def _bot_loop(self, client, username):
        """Keep bot connection alive"""
        try:
            print(f"[DEBUG] _bot_loop started for {username}")
            client.settimeout(60)
            while True:
                try:
                    data = client.recv(1024)
                    if not data:
                        print(f"[DEBUG] Bot {username} sent no data, keeping alive")
                        time.sleep(1)
                        continue
                except socket.timeout:
                    print(f"[DEBUG] Timeout for {username}, sending PING")
                    try:
                        client.send(b"PING\\n")
                    except:
                        print(f"[DEBUG] Failed to send PING to {username}")
                        break
                    continue
                except Exception as e:
                    print(f"[DEBUG] Error in _bot_loop: {e}")
                    break
        except Exception as e:
            print(f"[DEBUG] Outer error: {e}")
        finally:
            print(f"[DEBUG] Removing bot {username}")
            self.bot_manager.remove(client)
            try:
                client.close()
            except:
                pass
'''
    content = content.replace('    def _ping_bots_loop(self):', bot_loop + '\n    def _ping_bots_loop(self):')

# Fix the bot authentication
old_auth = '''if verify_bot_auth(password, username, self.bot_secret):
                self.bot_manager.register(client, address, username)
                return'''
new_auth = '''if verify_bot_auth(password, username, self.bot_secret):
                self.bot_manager.register(client, address, username)
                threading.Thread(target=self._bot_loop, args=(client, username), daemon=True).start()
                return'''
content = content.replace(old_auth, new_auth)

with open('main.py', 'w') as f:
    f.write(content)

print("✅ Server fixed!")
