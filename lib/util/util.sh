
#bash

function log_debug() {
	echo "uuu"
	if [ ! -z $2 ];then
		LOG_FILE=$2
	else
		LOG_FILE=`getconf LOG_FILE`
	fi
	echo "--------"`date +%Y%m%d%k%M%S` $0 "--------" >> $LOG_FILE;echo -e "[DEBUG] $1" >> $LOG_FILE
}

function log_info() {
	echo "eee"
	if [ ! -z $2 ];then
		LOG_FILE=$2
	else
		LOG_FILE=`getconf LOG_FILE`
	fi
	echo "--------"`date +%Y%m%d%k%M%S` $0 "--------" >> $LOG_FILE;echo -e "[INFO] $1" >> $LOG_FILE
}

function log_warning(){
	if [ ! -z $2 ];then
		LOG_FILE=$2
	else
		LOG_FILE=`getconf LOG_FILE`
	fi
	echo "--------"`date +%Y%m%d%k%M%S` $0"--------" >> $LOG_FILE
	echo "[[WARNING]] $1" >> $LOG_FILE
	echo "[[WARNING]] $1"
}

function log_fatal(){
	if [ ! -z $2 ];then
		LOG_FILE=$2
	else
		LOG_FILE=`getconf LOG_FILE`
	fi
	echo "--FATAL-- "`date +%Y%m%d%k%M%S` $0"--------" >> $LOG_FILE
	echo "[[[FATAL]]]] $1" >> $LOG_FILE
	echo "[[[FATAL]]] $1"
	exit 1
}


function getconf(){
	if [ ! -z $2 ];then
		CONFIG_FILE=$2
	else
		CONFIG_FILE="../../etc/configure.txt"
	fi
	echo "iii"
	conf=`cat $CONFIG_FILE | grep $1 | awk -F " " '{print $2}'`
	echo "iii"
	log_debug "getconf"
	echo "iii"
	echo $conf
	exit 0
}


function get_previous_filename() { #return filename
	NULL_FILELIST=`getconf NULL_FILELIST`
	#echo "$NULL_FILELIST"
	if [ ! -e $NULL_FILELIST ];then
 		exit 1
	 fi
	previous_filename=$DATADIR/`tail -n 2 $NULL_FILELIST | head -n 1`.csv
	if [ ! -e $previous_filename ];then
		log_info "[get_previous_filename] $previous_filename NOT exists"
		exit 1
	else
		echo $previous_filename
	fi
}

function get_latest_filename() { #return filename
	NULL_FILELIST=`getconf NULL_FILELIST`
	if [ ! -e $NULL_FILELIST ];then
 		exit 1
	fi
	latest_filename=$DATADIR/`tail -n 1 $NULL_FILELIST`.csv
	if [ ! -e $latest_filename ];then
		exit 1
	else
		echo $latest_filename
	fi
}

function cut_filedata() { #return cut filename
	target_file_name=$1
	log_info "[cut_filedata] target_file_name=$target_file_name"
	START_OF_RANKING=`getconf START_OF_RANKING`
	END_OF_RANKING=`getconf END_OF_RANKING`
	head -n $END_OF_RANKING $target_file_name \
		| tail -n `expr $END_OF_RANKING - $START_OF_RANKING + 1` \
		> cut.csv
	nkf -w --overwrite cut.csv
	echo cut.csv
}

function get_time_of_file() {
	filename=$1
	target_time=$2
	if [ $target_time = "hour" ];then
		time=`echo ${filename: -6:2}`
		log_info "get_time_of_file $filename $target_time is $time"
		echo $time
	fi

	#awk -F -  '{ print ; }' data/null-filelist.txt
	#IFS='-'
	#set --  ${latestFiles[0]}
	#timeofPreviousFile=`echo $3 | cut -c 1-2`
	#log_info "timeofPreviousFile=$timeofPreviousFile"
	#set -- ${latestFiles[1]}
	#timeofCurrentFile=`echo $3 | cut -c 1-2`
}

