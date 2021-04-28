#!/bin/sh

lsw | sed 's/[^ ]* //' | sort
