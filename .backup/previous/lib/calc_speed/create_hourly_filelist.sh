
##zsh
## util/createHourlyFilelist.sh
## arg[1] == all;then search all filenames
## arg[1] == current; then search only two latest filenames
##
cd `dirname $0` # calc_speedph/
SRCFILENAME="../data/null-filelist.txt"
HOURLYFILENAME="../data/null-hourly-filelist.txt"
if [ -z $1 ];then
	echo "CALCMODE is EMPTY"
	exit 1

elif [ $1 == "all" ];then
##initialize
:>$HOURLYFILENAME
	previousFile="null-00000000-000000"
	while read currentFile; do
		IFS='-'
		set -- $previousFile
		hourofPreviousFile=`echo $3 | cut -c 1-2`
		set -- $currentFile
		hourofCurrentFile=`echo $3 | cut -c 1-2`
		if [ $hourofPreviousFile == $hourofCurrentFile ];then
			:
		else
			echo "$1-$2-$3" >> $HOURLYFILENAME
		fi
	previousFile=$currentFile
	done < $SRCFILENAME

elif [ $1 == "current" ];then
	latestFiles=(`tail -2 $SRCFILENAME`)
	IFS='-'
	set --  ${latestFiles[0]}
	hourofPreviousFile=`echo $3 | cut -c 1-2`
	set -- ${latestFiles[1]}
	hourofCurrentFile=`echo $3 | cut -c 1-2`
	if [ $hourofPreviousFile == $hourofCurrentFile ];then
		:
	else
		echo "$1-$2-$3" >> $HOURLYFILENAME
	fi
else
	echo "MODE ERROR[$1]"
	exit 1
fi
#awk -F -  '{ print ; }' data/null-filelist.txt 
