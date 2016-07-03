
#bash
cd `dirname $0`
source "../util/util.sh"
echo "aaa"
log_info "sandbox"
echo "aaa"
str="aaa"
echo "aaa"
if [ -z $str ];then
	echo "null"
else
	echo $str
fi

echo `getconf NULL_FILELIST`
echo `getconf FAILED`