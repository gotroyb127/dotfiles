#!/bin/sh

{ echo "------------------ $(basename "$0"): $(date +%r) ------------------"
cat
echo "------------------------------------------------------------"
} >> "$STARTX_LOG"