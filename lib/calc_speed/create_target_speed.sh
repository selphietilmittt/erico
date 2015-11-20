
#bash
## calc_speedph/create_target_speed.sh
## arg[1] == target
cd `dirname $0`
getconf="../util/getconf.sh"
DATADIR=`./$getconf DATADIR`
OUTPUTDIR=`./$getconf OUTPUTDIR`
FILELIST="$DATADIR/null-hourly-filelist.txt"
SPEEDFILE="$OUTPUTDIR/speed.csv"
TARGET=$1


if [ -z $TARGET ];then
	echo "TARGET is EMPTY."
	exit 1
fi
if [ ! -e $SPEEDFILE ];then
	pwd
	echo "SPEEDFILE $SPEEDFILE NOT EXIST"
	exit 1
fi
if [ -e $OUTPUTDIR"/speed"$TARGET ];then
	mv $OUTPUTDIR/speed$TARGET.csv $OUTPUTDIR/speed$TARGET.csv.1
fi

iconv -f sjis -t UTF8 $SPEEDFILE | while read line; do
	#echo "$line" | grep -e ^,
	echo "iconv"
	if [ -n "`echo "$line" | grep -e ^,`" ];then
		echo "$line"
		#echo -n $line"," | iconv -f UTF8 -t sjis >> $ROOTDIR/speed$TARGET.csv
		echo -n $line"," >> $OUTPUTDIR/speed$TARGET.csv
	elif [ -n "`echo "$line" | grep $TARGET`" ];then
		echo $line
		#echo $line | iconv -f UTF8 -t sjis >> $ROOTDIR/speed$TARGET.csv
		echo $line >> $OUTPUTDIR/speed$TARGET.csv
	fi
done


exit 0
