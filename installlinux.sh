#!/usr/bin/env bash
mkdir ./bin
dub build --build=release
cp -r ./test ./bin
cp -r ./stdincludes ./bin/includes
cp -r ./logo ./bin
sudo mv ./bin/atto24 /usr/bin/atto24
sudo rm -r /etc/atto24
sudo mv ./bin /etc/atto24
sudo chmod -R 755 /etc/atto24