function fish_user_key_bindings
	bind -s --preset -M default L accept-autosuggestion
	bind -s --preset -M default \cf forward-char
	bind -s --preset -M default \cb backward-char
	bind -s --preset -M insert \cf forward-char
	bind -s --preset -M insert \cb backward-char
	bind -s --preset dw kill-word delete-char
end

