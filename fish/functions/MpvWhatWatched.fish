function MpvWhatWatched
	clear -x
	set -l box '==========----------------------------------------------------------------------=========='
	echo -n "$box"
	for f in (find ~/.config/mpv/watch_later -type f);
		for i in (head -n1 $f | tr -d '#');
			echo
			basename $i
		end
	end
	echo "$box"
	mksh -c 'read -n1'
end
