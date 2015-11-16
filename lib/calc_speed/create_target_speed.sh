
#bash
## calc_speedph/create_target_speed.sh
## arg[1] == target
cd `dirname $0`
ROOTDIR="../.."
CONFIG="$ROOTDIR/config.txt"
SPEEDFILE="$ROOTDIR/speed.csv"
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
#only the line head is ,
LINE=""
#iconv -f sjis -t UTF8 $SPEEDFILE | grep ^, | while read line; do
#	:
#done
#echo $LINE
mv $ROOTDIR/speed$TARGET.csv $ROOTDIR/speed$TARGET.csv.old
iconv -f sjis -t UTF8 $SPEEDFILE | while read line; do
	#echo "$line" | grep -e ^,
	if [ -n "`echo "$line" | grep -e ^,`" ];then
		echo "$line"
		#echo -n $line"," | iconv -f UTF8 -t sjis >> $ROOTDIR/speed$TARGET.csv
		echo -n $line"," >> $ROOTDIR/speed$TARGET.csv
	elif [ -n "`echo "$line" | grep $TARGET`" ];then
		echo $line
		#echo $line | iconv -f UTF8 -t sjis >> $ROOTDIR/speed$TARGET.csv
		echo $line >> $ROOTDIR/speed$TARGET.csv
	fi
done


exit 0
