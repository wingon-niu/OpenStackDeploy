#!/usr/bin/python

import sys
import os
import time
import fcntl
import struct
import socket
import subprocess

iniparse = None
psutil = None

def add_to_conf(conf_file, section, param, val):
    config = iniparse.ConfigParser()
    config.readfp(open(conf_file))
    if not config.has_section(section):
        config.add_section(section)
        val += '\n'
    config.set(section, param, val)
    with open(conf_file, 'w') as f:
        config.write(f)

def delete_from_conf(conf_file, section, param):
    config = iniparse.ConfigParser()
    config.readfp(open(conf_file))
    if param is None:
        config.remove_section(section)
    else:
        config.remove_option(section, param)
    with open(conf_file, 'w') as f:
        config.write(f)

def get_from_conf(conf_file, section, param):
    config = iniparse.ConfigParser()
    config.readfp(open(conf_file))
    if param is None:
        raise Exception("parameter missing")
    else:
        return config.get(section, param)

if __name__ == "__main__":
    length = len(sys.argv)
    if length != 5:
        print "set-config.py: wrong parameters."
        sys.exit(1)
    #print sys.argv[0]
    #print sys.argv[1]
    #print sys.argv[2]
    #print sys.argv[3]
    #print sys.argv[4]
    #global iniparse
    if iniparse is None:
        iniparse = __import__('iniparse')
    #global psutil
    if psutil is None:
        psutil = __import__('psutil')
    add_to_conf(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])

