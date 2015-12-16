
#bash
SRCDIR="../"
DSTDIR="../../erico-light"
cd `dirname $0`
if [ ! -d $DSTDIR ] ;then echo "erico-light not exist";exit 1;fi
rsync -av --exclude="._*" --exclude="configure.txt" --include="*/" --include="*.sh" --include="*.pl" --include="*.rb" --exclude="*" $SRCDIR $DSTDIR

