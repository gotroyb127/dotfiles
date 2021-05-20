#!/bin/sh

stamp=$(date '+%d_%m_%y.%H_%M_%S')

DDNet 2>&1 | tee /tmp/ddnet.$stamp.log
