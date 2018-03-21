#!/usr/bin/env bash
git pull https://github.com/matteoferla/pedel2.git;
kill $(ps aux | grep 'app.py' | awk '{print $2}');
nohup python3 app.py &