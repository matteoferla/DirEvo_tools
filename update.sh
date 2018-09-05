#!/usr/bin/env bash
git pull https://github.com/matteoferla/pedel2.git;
kill $(ps aux | grep 'app.py' | awk '{print $2}'); # sudo netstat -ltnp would be best...
#cd pyramidstarter/bikeshed
#sh compile.sh linux;
#cd ../..;
#chmod -R 777 .;
nohup python3 app.py > pyramidstarter/static/bash_log.txt &
echo 'All done!';
echo 'Having trouble: cat pyramidstarter/static/bash_log.txt';