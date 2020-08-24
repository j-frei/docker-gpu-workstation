#!/usr/bin/env python3

import os
from shlex import quote

skip_items = set((
    "TERM","HOME", "PWD", "_", "HOSTNAME"
))

for k,v in os.environ.items():
    if k in skip_items:
        continue
    print("export {}={}".format(quote(k),quote(v)))
