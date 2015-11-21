
#bash
cd `dirname $0`
getconf="../util/getconf.sh"


: <<'#__CO__'
calc_defeating_time_by_endnum.sh
	if all
	TARGETFILE=$1
	TARGETNUM=$2
	RANGE=$3
	tail $RANGE*10 | mod $TARGETNUM
	ave
	$latest-$RANGE"-"$latest-10,ave
#__CO__