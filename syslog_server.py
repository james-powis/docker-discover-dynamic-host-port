#!/usr/bin/env python

import sys
import socket
from timeout import timeout

UDP_IP = "0.0.0.0"
UDP_PORT = int(sys.argv[1])

sock = socket.socket(socket.AF_INET, # Internet
                 socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

@timeout(30)
def server():
    while True:
        data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
        print "received message:", data
        sys.exit(0)

if __name__ == "__main__":
    server()
