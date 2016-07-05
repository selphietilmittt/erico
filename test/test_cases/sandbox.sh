
# bash
cd `dirname $0`
source "../../lib/util/util.sh"

date=`date +%Y%m%d-%H%M%S`
min=`echo ${date: -4:2}`
echo $date
echo $min