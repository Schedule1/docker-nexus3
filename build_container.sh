#!/bin/bash

. gen_keystore.sh
PW=$(cat ./ssl/password)
sudo docker build --rm=true --tag=schedule1/nexus3 --build-arg KEYSTORE_PASSWORD=${PW} .