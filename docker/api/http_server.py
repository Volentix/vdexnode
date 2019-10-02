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

def location_scanner(locations_file):
    while True:
      locations = []
      try:
        process = subprocess.Popen("/usr/bin/dhtscanner -b 127.0.0.1 -n 1 -p 60999 | grep 'Node' | grep -v ':60999' | awk '{print $2 \"@\" $3}' | sed -e 's/:.*//'", shell=True, stdout=subprocess.PIPE,)
        for node in process.communicate()[0].decode("utf-8").split("\n"):
          if len(node) >= 40:
            locations.append(node)
        if len(locations) > 0:
          with open(locations_file, 'w') as f:
            for node in locations:
              f.write("%s\n" % node)
      except Exception as e:
          print("Error saving locations list to file" + e)
      time.sleep(30)
    return

class HTTPServer(resource.Resource):
    isLeaf = True
    urls={}
    nodeurl=""

    def __init__(self, nodes_file, nodeurl, locations_file):
        self.nodes_file=nodes_file
        self.locations_file = locations_file
        self.nodeurl=nodeurl

    def get_nodes_eoskeys(self):
      nodes_keys = {}
      try:
        r = requests.get(self.nodeurl+'/eos')
        content = r.content.decode("utf-8").split("\n")
        for j in content:
          if j != "\n" and j != "":
            data = json.loads(j)
            b64_string = data["data"]
            b64_string += "=" * ((4 - len(b64_string) % 4) % 4)
            for node, key in (json.loads(base64.b64decode(b64_string).decode("utf-8").split("\n")[0])).items():
              nodes_keys[node] = key
      except Exception as e:
          print(e)
      return nodes_keys

    def get_coordinates(self, array):
      locations={}
      for item in array:
        try:
          # TODO refactor, debug and test
          node_id, node_ip = item.split('@')
          r = requests.get('https://ipinfo.io/' + node_ip + '/json')
          content=r.content.decode("utf-8")
          ob = json.loads(content)
          if ob['loc'] and ob['city']:
            locations[node_id] = [ob['city'], ob['loc']]
        except Exception as e:
          print(e)
      return locations

    def render_GET(self, req):
        uri = req.uri[1:].decode().rsplit('?', 1)[0]
        time.sleep(1)
        if uri == 'getConnectedNodes':
           req.setHeader('Access-Control-Allow-Origin', '*')
           req.setHeader('Access-Control-Allow-Methods', 'GET')
           req.setHeader('Content-type', 'application/json')
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

        elif uri == 'getNodesLocation':
          req.setHeader('Access-Control-Allow-Origin', '*')
          req.setHeader('Access-Control-Allow-Methods', 'GET')
          req.setHeader('Content-type', 'application/json')
          result = {}
          try:
            f = open(self.locations_file, "r")
            lines = f.readlines()
            f.close()
          except:
            return json.dumps({'Result': 'Error. Try later'}).encode()

          locations = self.get_coordinates(lines)
          return json.dumps(locations).encode('utf-8')
        else:
          return json.dumps({'Result':'Null'}).encode()

if __name__ == '__main__':
    nodeurl="http://localhost:8100"
    nodes_file = '/api/nodes.txt'
    locations_file = '/api/locations.txt'
    _thread.start_new_thread(node_scanner, (nodes_file,))
    _thread.start_new_thread(location_scanner, (locations_file,))
    import argparse
    parser = argparse.ArgumentParser(description='Launch an OpenDHT api with an HTTP control interface')
    parser.add_argument('-hp', '--http-port', help='HTTP port to bind', type=int, default=9080)
    args = parser.parse_args()
    endpoints.serverFromString(reactor, "tcp:"+str(args.http_port)).listen(server.Site(HTTPServer(nodes_file, nodeurl, locations_file)))
    reactor.run()
