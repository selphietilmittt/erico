#bash
cd `dirname $0`
getconf="../util/getconf.sh"
util=`./$getconf UTILDIR`/util.sh
. $util
echo `get_previous_filename`


: <<'#__CO__'
calc_defeating_time

	CALCMODE=$1
	TARGET=$2
	filelist=
	outputfile=$OUTPUTDIR/defeating_time$TARGET.csv
	
	compare_with()
	get_defeated_num($TARGET)
	read_bottom_line(outputfile)
	replace_bottom_line(outputfile)
	
	
	if all
		defeating_time=1
		while defeating_num filelist; do
			defeated_num=get_defeated_num()
			if defeated_num = defeating_num
				defeating_time++
			else
				defeating_num=defeated_num
				defeating_time=1
			fi
			output#replace bottom line
		done
	fi
	if latest. $		previous.util`_file = get_previous_filename
		latest_fil`e = get_latest_filename
		output#replace bottom line
	fi
#__CO__