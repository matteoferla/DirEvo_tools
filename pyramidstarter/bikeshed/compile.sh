#!/usr/bin/env bash
os="linux"
g++ -o driver.batch.$os driver.batch.cxx
g++ -o driver.$os driver.cxx
g++ -o glue.$os glue.cxx
g++ -o pedel.batch.$os pedel.batch.cxx
g++ -o pedel_mc.$os pedel_mc.cxx
g++ -o driver_mc.$os driver_mc.cxx
g++ -o glue_mc.$os glue_mc.cxx
g++ -o pedel.$os pedel.cxx
g++ -o stats.batch.$os stats.batch.cxx
g++ -o glue1AAc glue1AAc.cxx
g++ -o glueITc glueITc.cxx
g++ -o glueNNS glueNNS.cxx
g++ -o pedel-AAc pedel-AAc.cxx
g++ -o stats.batch.mod.$os stats.batch.mod.cxx
g++ -o glue.mod.$os glue.mod.cxx