#!/usr/bin/env bash
if [ "$1" != "" ]; then
    os=$1
    for i in $( ls *.cxx);
    do
        g++ -std=c++98 -o "${i%.*}".$os "${i%.*}".cxx;
        echo "${i%.*}";
    done
else
    echo "Error in usage: bash compile.sh operating_sys_suffix"
fi
