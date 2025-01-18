#!/usr/bin/env bash
sudo rm -r /etc/atto24&&sudo rm /usr/bin/atto24
./installlinux.sh&&atto24 --run-tests;