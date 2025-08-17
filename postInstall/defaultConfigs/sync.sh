#!/bin/bash

# a simple script to backup my system configs

configsPath="$(cd $(dirname $0) && pwd)"

cp -r /etc/keyd/profiles/* $configsPath/keydProfiles
cp /etc/tlp.conf $configsPath/tlp.conf
cp /etc/thinkfan.conf $configsPath/thinkfan.conf
cp /usr/lib/systemd/system-sleep/thinkfan $configsPath/thinkfan.hook
