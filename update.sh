#!/usr/bin/env bash
echo '********** UPDATE *****************';
git pull https://github.com/matteoferla/pedel2.git;

echo '********** KILL *****************';
#kill $(ps aux | grep 'app.py' | awk '{print $2}'); # kill port 8080 only...
kill $(sudo netstat -ltnp | grep ':8080' | awk '{split($7,a,"/"); print a[1]}')

#echo '********** COMPILE *****************';
#cd pyramidstarter/bikeshed
#sh compile.sh linux;
#cd ../..;
#chmod -R 777 .;

echo '********** RUN *****************';
nohup python3 app.py >> pyramidstarter/static/bash_log.txt 2>>&1 &
echo 'All done!';
echo 'Having trouble: cat pyramidstarter/static/bash_log.txt';