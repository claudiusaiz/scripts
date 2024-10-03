#!/usr/bin/env python3
import socket
from http.server import HTTPServer
from http.server import SimpleHTTPRequestHandler

class HTTPServerV6(HTTPServer):
    address_family = socket.AF_INET6

server = HTTPServerV6(('::', 8080), SimpleHTTPRequestHandler)
server.serve_forever()
