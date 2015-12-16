
#bash
cd `dirname $0`

SRCDIR="../"
DSTDIR="/home/tilmi_000/f/game/puyoQue/personsantaamitie20151216"

if [ ! -d $DSTDIR ] ;then echo "targetdir[$DSTDIR] not exist";exit 1;fi
rsync -av --exclude="._*" --exclude="configure.txt" --include="*/" --include="*.sh" --include="*.pl" --include="*.rb" --include="*.txt" --exclude="*" $SRCDIR $DSTDIR
exit 0
