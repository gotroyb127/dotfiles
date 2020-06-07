function AdbGetFocus
	set F (adb shell dumpsys window windows | tr '/' '\n' | grep mCurrentFocus | awk '{print $3}')
	echo $F 1>&2
	echo $F
end
