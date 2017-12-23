#!/usr/bin/env python3
import os
import sys
import time
import math

at_least = int(sys.argv[1])
for process_id in os.listdir('/proc'):
    if not process_id.isdigit():
        continue
    try:
        cmdline = open(os.path.join('/proc', process_id, 'cmdline'), 'rb').read()
        if cmdline.startswith(b'radare2'):
            running_time = math.ceil(time.time() - os.stat(os.path.join('/proc', process_id)).st_mtime)
            if at_least < running_time:
                print(process_id)

    except IOError:  # proc has already terminated
        continue
