# useage ./newpost title
# $1 := titile

title=$1
year=`date '+%y'`
quoter=`date '+Q%q'`
date=`date '+%m%d-'`
path=posts/$year/$quoter/$date$title/index.md
hugo new $path
