function pathi
	switch $argv[2]
	case (seq 7)
		set C $argv[2]
		echo hehe
	case '*'
		set C 2
	end
	set pat (echo $argv[1] | string replace '\\' '\\\\' | string replace '/' '\\/')
	sed 's/\('"$pat"'\)/'(echo -en '\e[01;3'$C'm')'\1'(echo -en '\e[0m')'/g'
end
