#!/usr/bin/env bash
git pull https://github.com/matteoferla/pedel2.git;
kill $(ps aux | grep 'app.py' | awk '{print $2}');
cd pyramidstarter/bikeshed
sh compile.sh linux;
cd ../..;
nohup python3 app.py > pyramidstarter/static/bash_log.txt &
