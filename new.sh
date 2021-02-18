# useage ./newpost title
# $1 := titile

title=$1
year=`date '+%y'`
month=`date '+%m'`
date=`date '+%d-'`
#quoter=`date '+Q%q'` # for Linux, not for macOS
if [ $month == 01 ] || [ $month == 02 ] || [ $month == 03 ]; then
  quoter=1
elif [ $month == 04 ] || [ $month == 05 ] || [ $month == 06 ]; then
  quoter=2
elif [ $month == 07 ] || [ $month == 08 ] || [ $month == 09 ]; then
    quoter=3
else
    quoter=4
fi
path=posts/$year/Q$quoter/$month$date$title/index.md
hugo new $path
