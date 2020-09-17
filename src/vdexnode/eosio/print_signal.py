import signal
import time
import sys


print('START')

def sighandler(signum, frame):
    print("signum: {} frame: {}".format(signum, frame))

for i in [x for x in dir(signal) if x.startswith("SIG") and "_" not in x]:
    try:
        signum = getattr(signal, i)
        signal.signal(signum, sighandler)
    except (OSError, RuntimeError) as m: #OSError for Python3, RuntimeError for 2
        print ("Skipping {}".format(i))


while True:
    print('wating for signals')
    time.sleep(1)
