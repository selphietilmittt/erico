
## zsh
## arg[1] = filename
cd `dirname $0` # util/
if [ -z $1 ];then
	echo "Filename is empty"
	exit 2
elif [ -s $1 ];then
	echo "$1 exist"
	exit 1
else
	echo "$1 NOT exist"
	exit 0
fi
