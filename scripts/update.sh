#!/usr/bin/env bash
sudo rm -r /etc/atto24&&sudo rm /usr/bin/atto24
bash "${0%/*}/install.sh"&&atto24 --run-tests;
