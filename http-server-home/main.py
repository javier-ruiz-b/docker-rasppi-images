#!/usr/bin/python3
from flask import Flask, json, request
import os

companies = [{"id": 1, "name": "Company One"},
             {"id": 2, "name": "Company Two"}]

api = Flask(__name__)


def set_relay(device, setValue):
    value = 0
    print(f"pilight-control -d {device} -s {setValue}")
    for _ in range(3):
        value = os.system(f"pilight-control -d {device} -s {setValue}")
    return "ok"

@api.route('/all-off', methods=['GET'])
def all_off():
    value = 0
    for device in ['intertechno0', 'intertechno1', 'intertechno2']:
        value = set_relay(device, "off")
    os.system(f"curl http://127.0.0.1:8033/OFF")
    return "ok"

@api.route('/all-on', methods=['GET'])
def all_on():
    value = 0
    for device in ['intertechno0', 'intertechno1', 'intertechno2']:
        value = set_relay(device, "on")
    os.system(f"curl http://127.0.0.1:8033/ON")
    return "ok"

@api.route('/light-control', methods=['GET'])
def light():
    if request.args:
        items = dict(request.args.items())
        device = items['device']
        setValue = items['set']
        return set_relay(device, setValue)
    return f"Missing device and set args"


if __name__ == '__main__':
    api.run(host='0.0.0.0', port=8055)  # host='0.0.0.0',
