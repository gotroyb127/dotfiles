function fish_user_key_bindings
	bind -s --user -M default L accept-autosuggestion
	bind -s --user -M default \cf forward-char
	bind -s --user -M default \cb backward-char
	bind -s --user -M insert  \cf forward-char
	bind -s --user -M insert  \cb backward-char
	bind -s --user dW kill-bigword delete-char
	bind -s --user -M default \ec 'exec lf'
	bind -s --user -M insert  \ec 'exec lf'
end
