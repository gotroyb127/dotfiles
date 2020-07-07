#!/bin/mksh

BlocksDir="$(dirname $0)/statusblocks"
set -A Blocks	player	volume kblayout battery network date
set -A Signal	1	4	2	3	5	3
set -A UpdTime	1	10	10	10	10	1
set -A LastTime
set -A Out
N=$((${#Blocks[@]} -1))
Ns=$(seq 0 $N)
#SEP1=' '
#SEP2=''

Refresh()	{ Out[$1]="$($BlocksDir/${Blocks[$1]}.sh)"; }
HandleSignal()	{ Refresh $1; Print; }
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
	s="$((31-Signal[i]))"
	trap "HandleSignal $i" $s
	Refresh $i
done

while true; do
	Update
	Print
	sleep .9
done
