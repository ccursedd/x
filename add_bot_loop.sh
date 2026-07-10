#!/bin/bash

# Insert _bot_loop before _ping_bots_loop
sed -i '/def _ping_bots_loop/i\
    def _bot_loop(self, client, username):\
        """Keep bot connection alive"""\
        try:\
            client.settimeout(60)\
            while True:\
                try:\
                    data = client.recv(1024)\
                    if not data:\
                        continue\
                except socket.timeout:\
                    try:\
                        client.send(b"PING\\n")\
                    except:\
                        break\
                    continue\
                except:\
                    break\
        except:\
            pass\
        finally:\
            self.bot_manager.remove(client)\
            try:\
                client.close()\
            except:\
                pass' main.py

# Fix auth section
sed -i '/if verify_bot_auth(password, username, self.bot_secret):/,/return/ c\
            if verify_bot_auth(password, username, self.bot_secret):\
                self.bot_manager.register(client, address, username)\
                threading.Thread(target=self._bot_loop, args=(client, username), daemon=True).start()\
                return' main.py

echo "Done!"
