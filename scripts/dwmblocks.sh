#!/bin/mksh

BlocksDir="$(dirname $0)/statusblocks"
set -A Blocks	player volume kblayout battery network date
set -A Signal	5      4      3        2       6       1
set -A UpdTime	1     10     10       10      10      1
set -A LastTime
set -A Out
N=$((${#Blocks[@]} -1))
Ns=$(seq 0 $N)
#export SEP1=' '
#export SEP2=''

Refresh() { Out[$1]="$($BlocksDir/${Blocks[$1]}.sh)"; }
UpdateFast() { Refresh $1; Print; }
HandleSignal() { UpdateFast $1; }
Update() {
	for i in $Ns; do 
		((--LastTime[i]))
		if [[ ! ${LastTime[i]} -gt 0 ]]; then
			LastTime[i]="${UpdTime[i]}"
			Refresh $i
		fi
	done
}

Print() {
	xsetroot -name "$(for i in $Ns; do echo -n "${Out[i]}"; done)"
#	xsetroot -name "$(for i in $Ns; do echo -n "$SEP1${Out[i]}$SEP2"; done)"
}

# RTMIN: 34
for i in $Ns; do
	trap "HandleSignal $i" $((34+${Signal[i]}))
	Refresh $i
done

while true; do
	Update
	Print
	sleep .9
done

