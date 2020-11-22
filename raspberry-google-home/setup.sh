#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y python3-dev python3-venv
python3 -m venv env
env/bin/python -m pip install --upgrade pip setuptools wheel
source env/bin/activate

sudo apt-get install portaudio19-dev libffi-dev libssl-dev -y
python -m pip install --upgrade google-assistant-sdk[samples]

#generate credentials
python -m pip install --upgrade google-auth-oauthlib[tool]
google-oauthlib-tool --scope https://www.googleapis.com/auth/assistant-sdk-prototype \
	      --save --headless --client-secrets $HOME/client*.json






