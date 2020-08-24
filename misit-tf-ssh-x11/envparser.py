import os
from shlex import quote

for k,v in os.environ.items():
    print("{}={}".format(quote(k),quote(v)))
