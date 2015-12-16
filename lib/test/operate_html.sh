
#bash
cd `dirname $0`
source "../util/util.sh"

ROOTDIR=`getconf ROOTDIR`
OPERATE_HTML_DIR="$ROOTDIR/lib/html"
#date=`bash $OPERATE_HTML_DIR/get_html.sh`
#HTML_DIR=`getconf HTMLDIR`/$date
date="20151216-155154"
HTML_DIR=/home/alladmin/f/Dropbox/program/puyoque/data/html/20151216-155154


#target_categorys=(
#ALL_MEMBERS_RANKING
#GUILD_MEMBERS_RANKING
#BORDER_OF_RANKING
#)
target_categorys=(
ALL_MEMBERS_RANKING
)

for category in ${target_categorys[@]}; do
	HTML_LIST="$HTML_DIR/$category"_LIST
	merged_output=$HTML_DIR/$category.csv
	:>$merged_output
	cat $HTML_LIST | while read html_file; do
		log_info "convert_html_to_csv.sh $html_file"
		bash $OPERATE_HTML_DIR/convert_html_to_csv.sh $html_file $html_file.csv
		cat $html_file.csv >> $merged_output
	done
	log_info "merged_output=$merged_output"
done


exit 0
