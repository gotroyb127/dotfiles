function MpvWhatWatched
	echo -e '\n - - - - - - - - - - '
	for f in (ls);
		for i in (head -n1 $f | tr -d '#');
			basename $i
			echo ' - - - - - - - - - - '
		end
	end #| sort -n
	echo
end
