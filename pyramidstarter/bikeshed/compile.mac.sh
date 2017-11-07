#!/usr/bin/env bash
os="mac"
for i in $( ls *.cxx);
do
g++ -o "${i%.*}".$os "${i%.*}".cxx;
echo "${i%.*}";
done