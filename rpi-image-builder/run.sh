#!/bin/bash
set -euo pipefail

docker build -t rpi-image-cam .
docker run --rm -it -v "$(pwd)":/src rpi-image-cam