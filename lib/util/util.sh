
#bash
#echo "util.sh"
#pwd
#cd `dirname $0`
#pwd



function rotate_logfile(){
	if [ ! -z $1 ];then
		LOG_FILE=$1
	else
		LOG_FILE=`getconf LOG_FILE`
	fi
	if [ ! -e $LOG_FILE ];then
		cp /dev/null $LOG_FILE
	fi

	rotate_size=100000 #line
	logfile_line_num=`wc -l < $LOG_FILE`
	if [ $logfile_line_num -ge $rotate_size ];then
		last_logfile=`ls $LOG_FILE* | xargs -i basename {} | tail -n 1`
		IFS_ORIGINAL="$IFS"
		IFS=.
		arr=($last_logfile)
		num=`expr ${arr[1]} + 1`
		cp $LOG_FILE $LOG_FILE.$num
		cp /dev/null $LOG_FILE
	fi
}

function log_debug() {
	LOG_LEVEL=`getconf LOG_LEVEL`
	if [ $LOG_LEVEL == "DEBUG" ];then
		if [ -n $2 ];then
			LOG_FILE=$2
		else
			LOG_FILE=`getconf LOG_FILE`
		fi
		rotate_logfile $LOG_FILE
		echo "--------"`date +%Y%m%d%H%M%S` $0 "--------" >> $LOG_FILE;echo -e "[DEBUG] $1" >> $LOG_FILE
	fi
}

function log_info() {
	LOG_LEVEL=`getconf LOG_LEVEL`
	if [ $LOG_LEVEL == "DEBUG" -o $LOG_LEVEL == "INFO" ];then
		if [ -n $2 ];then
			LOG_FILE=$2
		else
			LOG_FILE=`getconf LOG_FILE`
		fi
		rotate_logfile $LOG_FILE
		echo "--------"`date +%Y%m%d%H%M%S` $0 "--------" >> $LOG_FILE;echo -e "[INFO] $1" >> $LOG_FILE
	fi
}

function log_warning(){
	LOG_LEVEL=`getconf LOG_LEVEL`
	if [ $LOG_LEVEL == "DEBUG" -o $LOG_LEVEL == "INFO" -o $LOG_LEVEL == "WARN" ];then
		if [ -n $2 ];then
			LOG_FILE=$2
		else
			LOG_FILE=`getconf LOG_FILE`
		fi
		rotate_logfile $LOG_FILE
		echo "--------"`date +%Y%m%d%H%M%S` $0"--------" >> $LOG_FILE
		echo "[[WARNING]] $1" >> $LOG_FILE
		echo "[[WARNING]] $1"
	fi
}

function log_fatal(){
	LOG_LEVEL=`getconf LOG_LEVEL`
	if [ $LOG_LEVEL == "DEBUG" -o $LOG_LEVEL == "INFO" -o $LOG_LEVEL == "WARN" -o $LOG_LEVEL == "FATAL" ];then
		if [ -n $2 ];then
			LOG_FILE=$2
		else
			LOG_FILE=`getconf LOG_FILE`
		fi
		rotate_logfile $LOG_FILE
		echo "--FATAL-- "`date +%Y%m%d%H%M%S` $0"--------" >> $LOG_FILE
		echo "[[[FATAL]]]] $1" >> $LOG_FILE
		echo "[[[FATAL]]] $1"
		exit 1
	fi
}

function getconf(){
	#set PATH of CONFIG_FILE
	if [ ! -z $2 ];then
		CONFIG_FILE=$2
	else
		CONFIG_FILE="../../etc/configure.txt"
	fi
	LOG_LEVEL=`cat $CONFIG_FILE | grep LOG_LEVEL | awk -F " " '{print $2}'`
	LOG_FILE=`cat $CONFIG_FILE | grep LOG_FILE | awk -F " " '{print $2}'`

	if [ $LOG_LEVEL == "DEBUG" ];then
		echo "--------"`date +%Y%m%d%H%M%S` $0 "--------" >> $LOG_FILE;echo -e "[DEBUG] getconf start. ARGV[1]=$1, ARGV[2]=$2, CONFIG_FILE=$CONFIG_FILE, LOG_LEVEL=$LOG_LEVEL, LOG_FILE=$LOG_FILE" >> $LOG_FILE
	fi
	if [ -z "$1" ];then
		LOG_FILE=`cat $CONFIG_FILE | grep LOG_FILE | awk -F " " '{print $2}'`
		echo "--FATAL-- "`date +%Y%m%d%H%M%S` $0"--------" >> $LOG_FILE
		echo "[[[FATAL]]]] ARGV[1] $1 is empty." >> $LOG_FILE
		exit 1
	fi
	if [ ! -e "$CONFIG_FILE" ];then
		LOG_FILE=`cat $CONFIG_FILE | grep LOG_FILE | awk -F " " '{print $2}'`
		echo "--FATAL-- "`date +%Y%m%d%H%M%S` $0"--------" >> $LOG_FILE
		echo "[[[FATAL]]]] CONFIG_FILE $CONFIG_FILE NOT exist." >> $LOG_FILE
		exit 1
	fi
	conf=`cat $CONFIG_FILE | grep $1 | awk -F " " '{print $2}'`
	if [ -z "$conf" ];then
		echo "--FATAL-- "`date +%Y%m%d%H%M%S` $0"--------" >> $LOG_FILE
		echo "[[[FATAL]]]] getconf [$1] NOT hit." >> $LOG_FILE
		exit 1
	fi
	if [ $LOG_LEVEL == "DEBUG" ];then
		echo "--------"`date +%Y%m%d%H%M%S` $0 "--------" >> $LOG_FILE;echo -e "[DEBUG] return $conf" >> $LOG_FILE
	fi
	echo $conf
	exit 0
}


function get_previous_filename() { #return filename
	DATADIR=`getconf DATADIR`
	NULL_FILELIST=`getconf NULL_FILELIST`
	if [ ! -e $NULL_FILELIST ];then
		log_fatal "[util.sh get_previous_filename] NULL_FILELIST is empty."
 		exit 1
	fi

	previous_filename=$DATADIR/`tail -n 2 $NULL_FILELIST | head -n 1`.csv
	if [ ! -e $previous_filename ];then
		log_fatal "[util.sh get_previous_filename] previous_file[$previous_file] is empty."
		exit 1
	else
		log_info "get_previous_filename return $previous_filename"
		echo $previous_filename
	fi
}


function get_latest_filename() { #return filename
	DATADIR=`getconf DATADIR`
	NULL_FILELIST=`getconf NULL_FILELIST`
	if [ ! -e $NULL_FILELIST ];then
		log_fatal "NULL_FILELIST NOT exist"
 		exit 1
	fi
	latest_filename=$DATADIR/`tail -n 1 $NULL_FILELIST`.csv
	log_debug "latest_filename=$latest_filename"
	if [ ! -e $latest_filename ];then
		log_fatal "[util.sh get_latest_filename] NULL_FILELIST is empty."
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
	case $target_time in
		"hour" ) time=`echo ${filename: -6:2}`;;
		"min" ) time=`echo ${filename: -4:2}`;;
		"sec" ) time=`echo ${filename: -2:2}`;;
		* ) log_fatal "[util.sh get_time_of_file] MODE ERROR[$2]";;
	esac
	log_info "get_time_of_file $filename $target_time is $time"
	echo $time
}

