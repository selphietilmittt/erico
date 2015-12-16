
# bash
cd `dirname $0`
source "../util/util.sh"
#CSVDIR=
#OUTPUTDIR=`getconf OUTPUTDIR`
INPUT_FILE=$1
OUTPUT_FILE=$2
log_info "convert_html_to_csv start\nfrom $INPUT_FILE\nto$OUTPUT_FILE"
:>$OUTPUT_FILE

ruby convert_html_to_csv.rb $INPUT_FILE $OUTPUT_FILE

exit 0

#done

#if [ ! -d $HTMLDIR ];then echo "HTMLDIR NOT exists"
#	exit 1
#fi
#if [ ! -d $OUTPUTDIR ];then; mkdir $OUTPUTDIR; fi

#target_html_name="aaa.html"
#output_csv_name="bbb.csv"
#ruby convert_html_to_csv.rb $target_html_name $output_csv_name