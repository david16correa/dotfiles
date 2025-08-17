#!/bin/bash

# a simple script to compare my backups with my system configs

configsPath="$(cd $(dirname $0) && pwd)"

echo -e "[\033[33mINFO\033[0m] keyd configs:"
echo $(diff -r /etc/keyd/profiles $configsPath/keydProfiles)
echo -e "[\033[33mINFO\033[0m] TLP configs:"
echo $(cp /etc/tlp.conf $configsPath/tlp.conf)
echo $(cp /etc/thinkfan.conf $configsPath/thinkfan.conf)
echo -e "[\033[33mINFO\033[0m] Thinkfan configs:"
echo $(cp /usr/lib/systemd/system-sleep/thinkfan $configsPath/thinkfan.hook)
