#!/bin/bash
# Example call: ./package.sh
VERSION=2.0.6

## Package the worker
source worker/venv/bin/activate
# change in controlnet_aux/zoe/zoedepth/models/layers/attractor.py
TAR_FILE=worker/venv/lib/python3.10/site-packages/controlnet_aux/zoe/zoedepth/models/layers/attractor.py
sed -i.bak "s/@torch.jit.script/#@torch.jit.script/g" $TAR_FILE

pyinstaller crynux_worker_process.spec

## Package the node
source venv/bin/activate
pyinstaller crynux.spec

## Copy the worker
mv "dist/crynux_worker_process" "dist/crynux-node/crynux_worker_process"

## Create the data and config folders
mkdir "dist/crynux-node/config"
cp "../../config/config.yml.package_example" "dist/crynux-node/config/config.yml"

mkdir "dist/crynux-node/data"
mkdir "dist/crynux-node/data/external"
mkdir "dist/crynux-node/data/huggingface"
mkdir "dist/crynux-node/data/results"
mkdir "dist/crynux-node/data/inference-logs"

## Copy the Web UI
mkdir "dist/crynux-node/webui"
cp -r "webui/dist" "dist/crynux-node/webui/"

## Copy the resources
cp -r "res" "dist/crynux-node/"

RELEASE_NAME="crynux-node-helium-v${VERSION}-linux-bin-x64"

mv dist/crynux_node "dist/$RELEASE_NAME"

## Generate the tar file
tar -czf "dist/$RELEASE_NAME.tar.gz" -C dist "$RELEASE_NAME"
