#!/usr/bin/env bash
if [[ $(uname -s) == "Linux" ]]; then
    sudo rm /usr/bin/atto24
fi
sudo rm -r /etc/atto24
bash "${0%/*}/install.sh"&&atto24 --run-tests;
