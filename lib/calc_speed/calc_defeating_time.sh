
#bash
cd `dirname $0`
source "../util/util.sh"

CALCMODE=$1
TARGET_GUILD=$2

FILELIST=`getconf NULL_FILELIST`
DATADIR=`getconf DATADIR`
OUTPUTFILE=`getconf DEFEATING_TIME_OF_`"$TARGET_GUILD.csv"
##OUTPUTFILE
## num, NAME, DEFEATING_TIME_OF
##	1
##	2
##	3
##	:

if [ ! -e $FILELIST ];then
	echo "calc_defeating_time.sh $FILELIST NOT exists."
	exit 1
fi


function get_defeated_num(){
	filename=$1
	target_guild=$2
	if [ ! -e $filename ];then
		echo "$filename NOT exists"
		exit 1
	fi
	echo `iconv -f sjis -t UTF8 $filename | grep $target_guild | awk -F, '{print $2}'`
}

function set_defeating_num_time(){
	TARGET_GUILD=$1
	defeating_num=$2
	defeated_num=$3
	defeating_time=$4
	#renew defeating_num, defeated_num, defeating_time
	defeating_num=`get_defeated_num $DATADIR/$filename".csv" $TARGET_GUILD`
	if [ "$defeated_num" == "$defeating_num" ];then
		## same boss
		defeating_time=`expr $defeating_time + 1`
		if [ "$defeating_time" == "" ];then
			echo "tednum: $defeated_num == tingnum: $defeating_num time: $defeating_time"
		fi
	else
		# next boss
		#echo "tednum: $defeatied_num != tingnum: $defeating_num time: $defeating_time"
		defeated_num=$defeating_num
		defeating_time=1
	fi
}

function fetch_bottom_line(){
	:
}


function renew_bottom_of_outputfile(){
	OUTPUTFILE=$1
	defeating_num=$2
	NAME=$3
	defeating_time=$4

	echo "$defeating_num,$NAME,$defeating_time," >> $OUTPUTFILE
}


if [ -z $CALCMODE ];then
	echo "calc_defeating_time.sh CALCMODE is EMPTY. please set all or latest"
	exit 1

elif [ $CALCMODE == "all" ];then
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
			$TARGET_GUILD \
			$defeating_num \
			$defeated_num \
			$defeating_time

		#echo $defeating_time
		renew_bottom_of_outputfile \
			$OUTPUTFILE \
			$defeating_num \
			$TARGET_GUILD \
			$defeating_time
	done
	#echo $defeating_num

elif [ $CALCMODE == "latest" ]; then
	echo "latest"
	previous_filename=`get_previous_filename`
	latest_filename=`get_latest_filename`

	echo "$latest_filename"
	echo "-"
	echo "$previous_filename"

	set_defeating_num_time\
			$TARGET_GUILD \
			$defeating_num \
			$defeated_num \
			$defeating_time

else
	echo "calc_defeating_time.sh  MODE ERROR[$CALCMODE]"
	exit 1
fi
