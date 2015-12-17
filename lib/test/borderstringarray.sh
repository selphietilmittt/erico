
#bash
cd `dirname $0`
source "../util/util.sh"
log_info "**.sh start"

string=`getconf BORDER_OF_RANKING_STRING`
string=`echo $string | sed 's/,/ /g'`
array=( $string )
for var in ${array[@]}; do
	echo $var
done
echo ${array[0]}
exit 0