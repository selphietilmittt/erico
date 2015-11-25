
##bash
## util/createHourlyFilelist.sh
## arg[1] = all;then search all filenames
## arg[1] = current; then search only two latest filenames
##
cd `dirname $0`
source "../util/util.sh"
log_info "create_hourly_filelist.sh start arg[1]=$1"

SRCFILENAME=`getconf NULL_FILELIST`
HOURLYFILENAME=`getconf NULL_HOURLYFILELIST`

if [ -z $1 ];then
	echo "CALCMODE is EMPTY"
	exit 1

elif [ $1 = "all" ];then
##initialize
	:>$HOURLYFILENAME
	previousFile="null-00000000-000000"
	while read currentFile; do
		IFS='-'
		set -- $previousFile
		hourofPreviousFile=`echo $3 | cut -c 1-2`
		set -- $currentFile
		hourofCurrentFile=`echo $3 | cut -c 1-2`
		if [ $hourofPreviousFile = $hourofCurrentFile ];then
			:
		else
			#echo "$1-$2-$3" >> $HOURLYFILENAME
			echo "$1-$2-$3" >> ../../data/null-hourly-filelist.txt
		fi
	previousFile=$currentFile
	done < $SRCFILENAME

elif [ $1 = "latest" ];then
	latestFiles=(`tail -2 $SRCFILENAME`)
	log_info "latestFile=$latestFiles"
	IFS='-'
	set --  ${latestFiles[0]}
	timeofPreviousFile=`echo $3 | cut -c 1-2`
	echo "timeofPreviousFile=$timeofPreviousFile"
	set -- ${latestFiles[1]}
	timeofCurrentFile=`echo $3 | cut -c 1-2`
	echo "timeofCurrentFile=$timeofCurrentFile"
	if [ "$hourofPreviousFile" = "$timeofCurrentFile" ];then
		echo "nothing to do"
	else
		echo "$1-$2-$3" >> "$HOURLYFILENAME"
		#echo "$1-$2-$3" >> ../../data/null-hourly-filelist.txt
	fi
else
	echo "MODE ERROR[$1]"
	exit 1
fi
#awk -F -  '{ print ; }' data/null-filelist.txt 
