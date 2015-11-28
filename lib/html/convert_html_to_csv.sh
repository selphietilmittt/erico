
# bash
cd `dirname $0`
source "../util/util.sh"
log_info "convert_html_to_csv start"
#CSVDIR=
OUTPUTDIR=`getconf OUTPUTDIR`
echo $1
#if [ ! -d $HTMLDIR ];then echo "HTMLDIR NOT exists"
#	exit 1
#fi
#if [ ! -d $OUTPUTDIR ];then; mkdir $OUTPUTDIR; fi

#target_html_name="aaa.html"
#output_csv_name="bbb.csv"
#ruby convert_html_to_csv.rb $target_html_name $output_csv_name