function MpvWhatWatched
	echo -en '\n - - - - - '
	for f in (ls);
		for i in (head -n1 $f | tr -d '#');
			echo
			basename $i
		end
	end #| sort -n
	echo -e ' - - - - - '
end
