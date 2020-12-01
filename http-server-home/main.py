#!/usr/bin/python3
from flask import Flask, json, request
import os

companies = [{"id": 1, "name": "Company One"},
             {"id": 2, "name": "Company Two"}]

api = Flask(__name__)

lights  = { "pc" : "0",
            "side" : "1",
            "tv" : "2" }

lights_command = "pilight-send -p kaku_switch -i 13965290 "

def set_light(device, value):
    if value != "on" and value != "off":
        return "Possible values: on or off\n"
    return execute(lights_command + f"--unit {device} --{value}")

def execute(command):
    if os.system(command) != 0:
        return "Error executing " + command
    return "ok\n"

@api.route('/all-off', methods=['GET'])
def all_off():
    return execute(lights_command + "--off --all; curl http://127.0.0.1:8033/OFF")

@api.route('/bar-on', methods=['GET'])
def bar_on():
    return execute("curl http://127.0.0.1:8033/ON")

@api.route('/all-on', methods=['GET'])
def all_on():
    return execute(lights_command + "--on --all")

@api.route('/tv', methods=['GET'])
def tv():
    return execute(lights_command + "--off --all; "+ lights_command + "--on --unit " + lights["tv"])

@api.route('/light', methods=['GET'])
def light():
    if request.args:
        items = dict(request.args.items())
        device = lights[items['device']]
        setValue = items['set']
        return set_light(device, setValue)
    return f"Missing device and set args"


if __name__ == '__main__':
    api.run(host='0.0.0.0', port=8055)  # host='0.0.0.0',
