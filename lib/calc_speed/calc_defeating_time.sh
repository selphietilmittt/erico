
#bash
cd `dirname $0`
source "../util/util.sh"

CALC_MODE=$1
TARGET_GUILD=$2

FILELIST=`getconf NULL_FILELIST`
DATADIR=`getconf DATADIR`
OUTPUTFILE=`getconf DEFEATING_TIME_OF`"$TARGET_GUILD.csv"


function get_defeated_num(){
	filename=$DATADIR/$1".csv"
	target_guild=$2
	if [ ! -e $filename ];then
		echo "$filename NOT exists"
		exit 1
	fi
	echo `iconv -f sjis -t UTF8 $filename | grep $target_guild | awk -F, '{print $2}'`
	
	#echo "$filelist, $target_guild"

}


if [ $CALC_MODE == "all" ];then
	defeating_time=1
	defeated_num=0
	cat $FILELIST | while read filename; do
		defeating_num=`get_defeated_num $filename $TARGET_GUILD`
		if [ $defeated_num == $defeating_num ];then
			defeating_time=`expr $defeating_time + 1`
			echo "tednum: $defeated_num == tingnum: $defeating_num time: $defeating_time"
		else
			echo "tednum: $defeatied_num != tingnum: $defeating_num time: $defeating_time"
			defeated_num=$defeating_num
			defeating_time=1
		fi
	done
	echo $defeating_num


elif [ $CALC_MODE == "latest" ]; then
	echo "latest"
fi


get_previous_filename
get_latest_filename



: <<'#__CO__'
	CALC_MODE=$1
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