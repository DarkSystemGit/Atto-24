#!/usr/bin/env bash
cd "${0%/*}/../"
if dub build --build=release; then
    mkdir ./bin
    cp -r ./test ./bin
    cp -r ./stdincludes ./bin/includes
    cp -r ./logo ./bin
    sudo mv ./bin /etc/atto24
    sudo chmod -R 755 /etc/atto24
    echo "/etc/atto24" | sudo tee -a /etc/paths
    echo "Installation complete"
else
    echo "Build failed"
    exit 1
fi