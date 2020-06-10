function MpvWhatWatched
	echo -en '\n - - - - - '
	for f in (find ~/.config/mpv/watch_later -type f);
		for i in (head -n1 $f | tr -d '#');
			echo
			basename $i
		end
	end
	echo -e ' - - - - - '
end
