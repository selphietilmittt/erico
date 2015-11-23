
#bash
cd `dirname $0`
source "../util/util.sh"

CALCMODE=$1
TARGET_GUILD=$2
log_info "this is calc_defeating_time"
log_info "CALCMODE=$CALCMODE TARGET_GUILD=$TARGET_GUILD"

FILELIST=`getconf NULL_FILELIST`
DATADIR=`getconf DATADIR`
OUTPUTFILE=`getconf DEFEATING_TIME_OF_`"$TARGET_GUILD.csv"
##OUTPUTFILE
## num, NAME, DEFEATING_TIME_OF_
##	1
##	2
##	3
##	:

if [ ! -e $FILELIST ];then
	echo "$FILELIST NOT exists."
	exit 1
fi
if [ -z $TARGET_GUILD ];then
	echo "TARGET_GUILD is EMPTY."
	exit 1
fi


function get_defeated_num(){
	filename=$1
	target_guild=$2
	log_info "[get_defeated_num] filename=$filename target_guild=$target_guild"

	if [ ! -e $filename ];then
		log_worning "[get_defeated_num] $filename NOT exists"
		exit 1
	fi
	cut_filename=`cut_filedata $filename`
	if [ ! -e $cut_filename ];then
		log_fatal "[get_defeated_num] cut_file $cut_filename NOT exists"
	fi
	defeated_num=`cat $cut_filename | grep $target_guild | awk -F, '{print $2}'`
	log_info "[get_defeated_num] return $defeated_num"
	if [ -z $defeated_num ];then log_fatal "[get_defeated_num] defeated_num=null"; fi
	echo $defeated_num
}

function set_defeating_num_time(){
	filename=$1
	TARGET_GUILD=$2
	defeated_num=$3
	defeating_num=$4
	defeating_time=$5
	log_info "[set_defeating_num_time] filename=$filename target_guild=$TARGET_GUILD"
	if [ -z  $filename -o -z $TARGET_GUILD ];then
		log_warning "[set_defeating_num_time] filename or TARGET_GUILD is EMPTY"
		log_warning "[set_defeating_num_time] filename=$filename target_guild=$target_guild"
	fi
	#renew defeating_num, defeated_num, defeating_time
	defeating_num=`get_defeated_num  $filename $TARGET_GUILD`
	if [ -z "$defeated_num" ];then
		log_warning "[set_defeating_num_time] defeated_num==null"
		log_warning "ted: $defeated_num ting: $defeating_num time: $defeating_time"
	fi
	if [ -z "$defeating_num" ];then
		log_warning "[set_defeating_num_time] defeating_num==null"
		log_warning "ted: $defeated_num ting: $defeating_num time: $defeating_time"
	fi

	if [ "$defeated_num" == "$defeating_num" ];then
		## same boss
		defeating_time=`expr $defeating_time + 1`
	else
		# next boss
		#echo "tednum: $defeatied_num != tingnum: $defeating_num time: $defeating_time"
		defeated_num=$defeating_num
		defeating_time=1
	fi
}

function fetch_bottom_line(){ #OUTPUTFILE num NAME DEFEATING_TIME_OF_
	log_info "[fetch_bottom_line] OUTPUTFILE=$OUTPUTFILE"
	if [ ! -e $OUTPUTFILE ];then
		log_info "OUTPUTFILE NOT exists"
		log_info "touch $OUTPUTFILE"
		touch $OUTPUTFILE
		echo "null"
	else
		log_info "OUTPUTFILE exists"
		last_line=`tail -n 1 $OUTPUTFILE`
		log_info "last_line=$last_line"
		if [ -z $last_line ];then
			log_info "last_line is empty. return null"
			echo "null"
		else
			log_info "last_line is $last_line"
			#cut + split
		fi
	fi

}


function renew_bottom_of_outputfile(){
	log_info "[renew_bottom_of_outputfile] OUTPUTFILE=$OUTPUTFILE"
	OUTPUTFILE=$1
	defeating_num=$2
	NAME=$3
	defeating_time=$4

	fetch_bottom_line $OUTPUTFILE

	echo "$defeating_num,$NAME,$defeating_time," >> $OUTPUTFILE
}


if [ -z $CALCMODE ];then
	echo "calc_defeating_time.sh CALCMODE is EMPTY. please set all or latest"
	exit 1

elif [ $CALCMODE == "all" ];then
	log_info "CALCMODE==all"
	if [ ! -e $OUTPUTFILE ];then
		echo "calc_defeating_time.sh $OUTPUTFILE NOT exists. creating"
		touch $OUTPUTFILE
	else
		rm $OUTPUTFILE
	fi

	defeating_time=1
	defeated_num=0
	cat $FILELIST | while read filename
	do
		#renew defeating_num, defeated_num, defeating_time
		set_defeating_num_time \
			$DATADIR/$filename".csv"\
			$TARGET_GUILD \
			$defeated_num \
			$defeating_num \
			$defeating_time
		echo "$filename :defeating_num = $defeating_num"

		#echo $defeating_time
		renew_bottom_of_outputfile \
			$OUTPUTFILE \
			$defeating_num \
			$TARGET_GUILD \
			$defeating_time
	done
	#echo $defeating_num

elif [ $CALCMODE == "latest" ]; then
	log_info "CALCMODE==latest"
	previous_filename=`get_previous_filename`
	log_info "[main] previous_filename=$previous_filename"
	latest_filename=`get_latest_filename`
	log_info "[main] latest_filename=$latest_filename"

	defeating_time=0 #fetch_bottom_line()
	defeated_num=`get_defeated_num $previous_filename $TARGET_GUILD`
	defeating_num=`get_defeated_num $latest_filename $TARGET_GUILD`

	set_defeating_num_time \
		$latest_filename \
		$TARGET_GUILD \
		$defeated_num \
		$defeating_num \
		$defeating_time

	renew_bottom_of_outputfile \
		$OUTPUTFILE \
		$defeating_num \
		$TARGET_GUILD \


else
	echo "calc_defeating_time.sh  MODE ERROR[$CALCMODE]"
	exit 1
fi
