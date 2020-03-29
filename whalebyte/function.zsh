# Will commit backup for quiver notes. Pass the version in like "quiverB mm/dd/yy"
#
function notesB() {
	pw=`pwd`
	if [ ${#1} -ne 0 ]; then
		cd ~/.whalebyte/notes && gaa && sleep 2 &&  gcmsg "backup $1" && sleep 2 && git push origin master && sleep 6
   	else
		cd ~/.whalebyte/notes && gaa && sleep 2 &&  gcmsg "backup" && sleep 2 && git push origin master && sleep 6
   	fi
	cd $pw
}
