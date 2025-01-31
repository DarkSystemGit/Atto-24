#!/usr/bin/env bash
cd "${0%/*}/../"
if dub build --build=release; then
    mkdir ./bin
    cp -r ./test ./bin
    cp -r ./stdincludes ./bin/includes
    cp -r ./logo ./bin
    sudo mv ./bin/atto24 /usr/bin/atto24
    sudo mv ./bin /etc/atto24
    sudo chmod -R 755 /etc/atto24
    echo "Installation complete"
else
    echo "Build failed"
    exit 1
fi