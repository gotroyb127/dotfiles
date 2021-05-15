#!/bin/sh

stamp=$(date '+%d_%m_%y')

DDNet 2>&1 | tee /tmp/ddnet.$stamp.log
