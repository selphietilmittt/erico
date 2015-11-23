
#bash
cd `dirname $0`
source "../util/util.sh"

CALCMODE=$1
TARGET_GUILD=$2

FILELIST=`getconf NULL_FILELIST`
DATADIR=`getconf DATADIR`
OUTPUTFILE=`getconf DEFEATING_TIME_OF_`"$TARGET_GUILD.csv"

##OUTPUTFILE
## num, TARGET_GUILD, DEFEATING_TIME_OF
##
##
##
##


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
	#renew defeating_num, defeated_num, defeating_time
	defeating_num=`get_defeated_num $DATADIR/$filename".csv" $TARGET_GUILD`
	if [ "$defeated_num" == "$defeating_num" ];then
		## same boss
		defeating_time=`expr $defeating_time + 1`
		#echo "tednum: $defeated_num == tingnum: $defeating_num time: $defeating_time"
	else
		# next boss
		#echo "tednum: $defeatied_num != tingnum: $defeating_num time: $defeating_time"
		defeated_num=$defeating_num
		defeating_time=1
	fi
}

#function renew_bottom_of_outputfile(){
#	OUTPUTFILE=$1
#	echo "OUTPUT_FILE=$OUTPUTFILE"
#}


if [ -z $CALCMODE ];then
	echo "calc_defeating_time.sh CALCMODE is EMPTY. please set all or latest"
	exit 1
elif [ $CALCMODE == "all" ];then
	defeating_time=1
	defeated_num=0
	cat $FILELIST | while read filename; do
		#renew defeating_num, defeated_num, defeating_time
		set_defeating_num_time
	done
	#echo $defeating_num

elif [ $CALCMODE == "latest" ]; then
	echo "latest"
else
	echo "calc_defeating_time.sh  MODE ERROR[$CALCMODE]"
	exit 1
fi


get_previous_filename
get_latest_filename



: <<'#__CO__'
	CALCMODE=$1
	TARGET_GUILD=$2
	filelist=
	outputfile=$OUTPUTDIR/defeating_time$TARGET.csv
	
	compare_with()
	get_defeated_num($TARGET_GUILD)
	read_bottom_line(outputfile)
	replace_bottom_line(outputfile)
	
	
	if all
		defeating_time=1
		while defeating_num filelist; do
			defeated_num=get_defeated_num()
			if defeated_num = defeating_num
				defeating_time++
			else
				defeating_num=defeated_num
				defeating_time=1
			fi
			output#replace bottom line
		done
	fi
	if latest
		previous_file = get_previous_filename
		latest_file = get_latest_filename
		output#replace bottom line
	fi

#__CO__