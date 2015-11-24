
#bash
#cd `dirname $0`
#getconf="../util/getconf.sh"

function log_info() {
	LOG_FILE=`getconf LOG_FILE`
	echo "--------"`date +%Y%m%d%k%M%S` $0"--------" >> $LOG_FILE;echo "[INFO] $1" >> $LOG_FILE
}

function log_warning(){
	LOG_FILE=`getconf LOG_FILE`
	echo "--------"`date +%Y%m%d%k%M%S` $0"--------" >> $LOG_FILE
	echo "[[WARNING]] $1" >> $LOG_FILE
	echo "[[WARNING]] $1"
}

function log_fatal(){
	LOG_FILE=`getconf LOG_FILE`
	echo "--FATAL-- "`date +%Y%m%d%k%M%S` $0"--------" >> $LOG_FILE
	echo "[[[FATAL]]]] $1" >> $LOG_FILE
	echo "[[[FATAL]]] $1"
	exit 1
}


function getconf(){
	CONFIG_FILE="../../etc/configure.txt"
	ROOTDIR=`cat $CONFIG_FILE | grep ROOTDIR | awk -F " " '{print $2}'`
	cat $CONFIG_FILE | grep $1 | awk -F " " '{print $2}'
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

