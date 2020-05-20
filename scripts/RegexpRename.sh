#!/bin/mksh

export IFS=$'\t\n'
#export  SED_CMD=$'-e\ts/\ I[.] /\ 1. /g\t'\
#\	\	$'-e\ts/\ II[.] /\ 2. /g\t'\
#\	\	$'-e\ts/\ III[.] /\ 3. /g\t'\
#\	\	$'-e\ts/\ IV[.] /\ 4. /g\t'\
#\	\	$'-e\ts/\ V[.] /\ 5. /g\t'\
#\	\	$'-e\ts/\ VI[.] /\ 6. /g\t'\
#\	\	$'-e\ts/\ VII[.] /\ 7. /g\t'\
#\	\	$'-e\ts/\ VIII[.] /\ 8. /g\t'\
#\	\	$'-e\ts/\ IX[.] /\ 9. /g\t'\
#\	\	$'-e\ts/\ X[.] /\ 10. /g\t'\
#\	\	$'-e\ts/\ XI[.] /\ 11. /g\t'

for i in $(find "$1" -type f | sort -n); do
#	mv -iv "$i" "$(dirname $i)/$(basename $i | sed $SED_CMD )"
	echo "$i:\n"$(dirname $i)/$(basename $i | sed $SED_CMD )""
#	echo -e "Testing: 1 I I. 2 II II. 3 III III. " | sed $SED_CMD
done

