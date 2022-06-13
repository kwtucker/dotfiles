#!/usr/bin/env fish
function abort
	echo [(set_color --bold yellow) ABRT (set_color normal)] $argv
	exit 1
end
