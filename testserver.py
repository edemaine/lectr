#!/usr/bin/python3
import os, sys

## Disable setuid for test server
os.setuid = lambda id: id
## Disable fork for better working on Windows.
## (Must come before importing http.server.)
if hasattr(os, 'fork'): delattr(os, 'fork')

try:
  from http.server import CGIHTTPRequestHandler as CGIHTTPRequestHandler
  from http.server import HTTPServer
except ImportError:
  from BaseHTTPServer import HTTPServer
  from CGIHTTPServer import CGIHTTPRequestHandler as CGIHTTPRequestHandler

class Handler(CGIHTTPRequestHandler):
  def is_python(self, path):
    return path.endswith('.cgi')
  def is_cgi(self):
    if not self.path.endswith('.cgi'): return False
    parentDirs, script = self.path.rsplit('/', 1)
    self.cgi_info = (parentDirs, script)
    return True

def run(port = 8000):
  os.chdir(os.path.join(os.path.dirname(__file__), 'dist'))
  server_address = ('', port)
  print('Running server on port %d. Connect to http://localhost:%d/' %
    (port, port))
  HTTPServer(server_address, Handler).serve_forever()

def main():
  if len(sys.argv) > 1:
    run(int(sys.argv[1]))
  else:
    run()

if __name__ == '__main__': main()
