#!/bim/bash

. env/bin/activate
#python3 textinput.py --device-model-id profound-gantry-296415-raspiberlingooglehome-yvpb3i --device-id 1
 python3 pushtotalk.py --device-model-id profound-gantry-296415-raspiberlingooglehome-yvpb3i --project-id RaspiBerlinGoogleHome --device-id 1 --audio-sample-rate 44100
