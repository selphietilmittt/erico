
# bash
cd `dirname $0`
source "../util/util.sh"
#CSVDIR=
OUTPUTDIR=`getconf OUTPUTDIR`
HTML_LIST=$1
HTML_LIST="/Volumes/share/Dropbox/program/puyoque/data/html/20151128-214715/html_list"
log_info "convert_html_to_csv start HTML_LIST=$HTML_LIST"
output_csv="output_csv"
#cat $HTML_LIST | while read html_file; do
	html_file=/Volumes/share/Dropbox/program/puyoque/data/html/20151128-214715/BORDER_OF_RANKING1
	ruby convert_html_to_csv.rb $html_file $output_csv
#done

#if [ ! -d $HTMLDIR ];then echo "HTMLDIR NOT exists"
#	exit 1
#fi
#if [ ! -d $OUTPUTDIR ];then; mkdir $OUTPUTDIR; fi

#target_html_name="aaa.html"
#output_csv_name="bbb.csv"
#ruby convert_html_to_csv.rb $target_html_name $output_csv_name