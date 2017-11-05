#!/usr/bin/env bash
os="linux"
for i in $( ls /opt/app-root/src/pyramidstarter/bikeshed/*.cxx);
do
g++ -o "${i%.*}".$os "${i%.*}".cxx;
done