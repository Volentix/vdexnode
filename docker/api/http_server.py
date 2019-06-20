#!/usr/bin/env python3

from twisted.web import server, resource
from twisted.internet import reactor, endpoints
from urllib.parse import urlparse

import time, base64, json, requests, _thread, subprocess

def node_scanner(nodes_file):
    while True:
      nodes=[]
      try:
        process = subprocess.Popen("/usr/bin/dhtscanner -b 127.0.0.1 -n 1 -p 60999 | grep 'Node' | grep -v ':60999' | awk '{print $2}'",shell=True,stdout=subprocess.PIPE,)
        for node in process.communicate()[0].decode("utf-8").split("\n"):
          if len(node)>=40:
            nodes.append(node)
        if len (nodes)>0:
          with open(nodes_file, 'w') as f:
            for node in nodes:
              f.write("%s\n" % node)
      except e:
          print ("Error saving nodes list to file"+e)
      time.sleep(30)
    return

class HTTPServer(resource.Resource):
    isLeaf = True
    urls={}
    nodeurl=""

    def __init__(self, nodes_file, nodeurl):
        self.nodes_file=nodes_file
        self.nodeurl=nodeurl

    def get_nodes_eoskeys(self):
        nodes_keys={}
        try:
           r = requests.get(self.nodeurl+'/eos')
           content=r.content.decode("utf-8").split("\n")
           for j in content:
             if j!="\n" and j!="":
               data=json.loads(j)
               b64_string=data["data"]
               b64_string += "=" * ((4 - len(b64_string) % 4) % 4)
               for node, key in (json.loads(base64.b64decode(b64_string).decode("utf-8").split("\n")[0])).items():
                 nodes_keys[node]=key
        except Exception as e:
           print (e)
        return nodes_keys

    def render_GET(self, req):
        uri = req.uri[1:].decode().rsplit('?', 1)[0]
        if uri == 'getConnectedNodes':
           result={'Result':'Success'}
           try:
             f = open(self.nodes_file, "r")
             lines = f.readlines()
             f.close()
           except:
             return json.dumps({'Result':'Error.Try later'}).encode()
           eos_keys=self.get_nodes_eoskeys()
           for l in lines:
              n=l.split("\n")[0]
              if n in eos_keys:
                 result[n]=eos_keys[n]
              else:
                 result[n]=""
           return json.dumps(result).encode('utf-8')
        return json.dumps({'Result':'Null'}).encode()

if __name__ == '__main__':
    nodeurl="http://localhost:8100"
    nodes_file = '/api/nodes.txt'
    _thread.start_new_thread(node_scanner, (nodes_file,))
    import argparse
    parser = argparse.ArgumentParser(description='Launch an OpenDHT api with an HTTP control interface')
    parser.add_argument('-hp', '--http-port', help='HTTP port to bind', type=int, default=9080)
    args = parser.parse_args()
    endpoints.serverFromString(reactor, "tcp:"+str(args.http_port)).listen(server.Site(HTTPServer(nodes_file,nodeurl)))
    reactor.run()
