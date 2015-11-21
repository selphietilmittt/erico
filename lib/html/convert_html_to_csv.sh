
# bash
echo "this is convert_html_to_csv.sh"
cd `dirname $0`
getconf="../util/getconf.sh"
HTMLDIR=`./$getconf HTMLDIR`
OUTPUTDIR=`./$getconf OUTPUTDIR`

#if [ ! -d $HTMLDIR ];then echo "HTMLDIR NOT exists"
#	exit 1
#fi
#if [ ! -d $OUTPUTDIR ];then; mkdir $OUTPUTDIR; fi

target_html_name="aaa.html"
output_csv_name="bbb.csv"
ruby convert_html_to_csv.rb $target_html_name $output_csv_name