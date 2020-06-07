function AdbUninstall
	adb shell pm uninstall -k --user 0 $argv[1]
end
