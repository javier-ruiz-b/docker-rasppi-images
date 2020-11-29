#!/usr/bin/env python
from flask import Flask, json, request
import os

companies = [{"id": 1, "name": "Company One"},
             {"id": 2, "name": "Company Two"}]

api = Flask(__name__)


def set_relay(device, value):
    value = 0
    for _ in range(3):
        value = os.system(f"pilight-control -d {device} -s {value}")
    return value

@api.route('/all-off', methods=['GET'])
def all_off():
    value = 0
    for device in ['intertechno0', 'intertechno1', 'intertechno2']:
        value = set_relay(device, "off")
    return value

@api.route('/light-control', methods=['GET'])
def light():
    if request.args:
        items = dict(request.args.items())
        device = items['device']
        setValue = items['set']
        return set_relay(device, setValue)
    return f"Missing device and set args"


if __name__ == '__main__':
    api.run(port=8055)  # host='0.0.0.0',
