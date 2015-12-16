
##bash
## util/createHourlyFilelist.sh
## arg[1] = all;then search all filenames
## arg[1] = current; then search only two latest filenames
##
cd `dirname $0`
source "../util/util.sh"
log_info "create_hourly_filelist.sh start arg[1]=$1"

FILELIST=`getconf NULL_FILELIST`
HOURLYFILELIST=`getconf NULL_HOURLYFILELIST`

if [ -z $1 ];then
	log_fatal "[create_hourly_filelist.sh] CALCMODE is EMPTY"
	exit 1

elif [ $1 = "all" ];then
##initialize
	log_info "initialize HOURLYFILELIST [$HOURLYFILELIST]"
	:>$HOURLYFILELIST
	previous_filename="null-00000000-000000"

	while read current_filename; do
		IFS='-'
		set -- $previous_filename
		previous_hour=`echo $3 | cut -c 1-2`
		set -- $current_filename
		current_hour=`echo $3 | cut -c 1-2`
		if [ $previous_hour = $current_hour ];then
			:
		else
			echo "$1-$2-$3" >> "$HOURLYFILELIST"
		fi
	previous_filename=$current_filename
	done < "$FILELIST"
	log_info "create HOURLYFILELIST finished"
elif [ $1 = "latest" ];then
	latest_filename=`tail -n 1 $FILELIST`
	if [ ! -e $HOURLYFILELIST ];then
		log_info "HOURLYFILELIST NOT exists. created."
		echo $latest_filename > "$HOURLYFILELIST"
	else
		previous_filename=`tail -n 1 $HOURLYFILELIST`
		log_info "\\nprevious_filename=$previous_filename\\nlatest_filename=$latest_filename"

		previous_hour=`get_time_of_file $previous_filename "hour"`
		latest_hour=`get_time_of_file $latest_filename "hour"`
		log_info "\\nprevious_hour=$previous_hour\\nlatest_hour=$latest_hour"

		if [ "$previous_hour" = "$latest_hour" ];then
			log_info "previous_hour = latest_hour nothing to do"
		else
			log_info "add latest_filename[$latest_filename] to $HOURLYFILELIST"
			echo $latest_filename >> "$HOURLYFILELIST"
			#echo "$1-$2-$3" >> "$HOURLYFILENAME"
			#echo "$1-$2-$3" >> ../../data/null-hourly-filelist.txt
			:
		fi
	fi

else
	log_fatal "[create_hourly_filelist.sh] MODE ERROR[$1]"
	exit 1
fi


exit 0
