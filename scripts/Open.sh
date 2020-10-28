#!/bin/sh

T='	'
IFS='
'
PGroup=\
'	\\.(pdf|djvu)$
	\\.pptx{0,1}$
	\\.(od[ft]|docx{0,1})$
	\\.(png|jpe{0,1}g|JPG|webp|svg|tiff|gif)$
	\\.(mid|MID)$
	\\.((mp|MP)[34]|mk[av]|ogg|wav|webm)$
	\\.html{0,1}$
	$'

Opener=\
"	a	zathura
	a	loimpress
	a	lowriter
	c	sxiv -o
	f	timidity -in
	f	mpv --input-ipc-server=$MPVSOCKET
	f	w3m -N
	f	nvim"

for arg in $*
do
	[ -d "$arg" ] && continue
	printf '%s\n' "$arg"
done |
	awk -v PGroups="${PGroup#$T}" \
	    -v Openers="${Opener#$T}" \
	'BEGIN {
		_ = split(PGroups, PGroup, "[\t\n]+")
		_ = split(Openers, Opener, "[\t\n]+")
		_ = split("", FGroups)
	} {
		for (i in PGroup) {
			if (match($0, PGroup[i])) {
				gsub("([\"$`])", "\\\\&")
				FGroups[i] = FGroups[i] " \"" $0 "\""
				break
			}
		}
	} END {
		for (i in FGroups) {
			postfix = ""
			# default: (Opener[i*2-1] == "f"), postfix = ""
			if (Opener[i*2-1] == "a")
				postfix = "2> /dev/null &"
			else if (Opener[i*2-1] == "c")
				postfix = "2> /dev/null | xsel -ib &"
			printf "%s%s\n%s\n",Opener[i*2],FGroups[i],postfix
		}
	}' | (
	IFS=' 	
'
	while read -r cmdl
	do
		read -r postfix
		printf '%s\n\n' "$cmdl" | sed 's/\s*"\([^"]*\)"/\n\1/g' |
			LF_Fihi
		eval "$cmdl $postfix"
	done
)
