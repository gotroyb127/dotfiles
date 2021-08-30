#!/bin/sh

T='	'
IFS='
'
PGroup=\
'	\\.(ps|pdf|djvu|epub)$\
	\\.(ppt|pptx)$\
	\\.(od[ft]|doc|docx)$\
	\\.(png|jpg|jpeg|JPG|webp|svg|tiff|gif)$\
	\\.(mid|MID)$\
	\\.((mp|MP)[34]|m4a|mk[av]|ogg|wav|webm)$\
	\\.htm|html$\
	$\
'

Opener=\
"	a	zathura\
	a	loimpress\
	a	lowriter\
	c	sxiv -o\
	f	timidity -in\
	f	mpvs --ao=alsa,pulse\
	f	w3m -N\
	f	vis\
"

for arg in "$@"
do
	[ -d "$arg" ] &&
		continue
	printf '%s\n' "$arg"
done |
	awk -v PGroups="${PGroup#$T}" \
	    -v Openers="${Opener#$T}" \
	'BEGIN {
		n = split(PGroups, PGroup, "[\t\n]+")
		m = split(Openers, Opener, "[\t\n]+")
		_ = split("", FGroups)
	} {
		for (i = 1; i <= n; i++) {
			if (match($0, PGroup[i])) {
				gsub("([\"$`])", "\\\\&")
				FGroups[i] = FGroups[i] " \"" $0 "\""
				break
			}
		}
	} END {
		for (i = 1; i <= n; i++) {
			if (FGroups[i] == "")
				continue
			postfix = ""
			# default: (Opener[i*2-1] == "f"), postfix = ""
			if (Opener[i*2-1] == "a")
				postfix = "2> /dev/null &"
			else if (Opener[i*2-1] == "c")
				postfix = "2> /dev/null | xsel -ib &"
			printf "%s%s\n%s\n", Opener[i*2], FGroups[i], postfix
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
