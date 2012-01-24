#!/bin/bash

#
# wikipedia.sh - Forget the regular encyclopedia
#
# 2008 - Mike Golvach - eggi@comcast.net
#
# Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
#

numargs=$#

if [ $numargs -lt 1 ]
then
echo "Usage: $0 Your Wikipedia Query"
echo "Ex: $0 linux"
echo "Ex: $0 \"linux kernel"
echo "Quotes only necessary if you use apostrophes, etc"
exit 1
fi

if [ $numargs -gt 1 ]
then
args=`echo $args|sed 's/ /_/g'`
fi

echo

args="$@"
wget=/usr/bin/wget
pager=/bin/more

$wget -nv -O - "http://en.wikipedia.org/wiki/${args}" 2>&1|grep -i "Wikipedia does not have an article with this exact name" >/dev/null 2>&1

anygood=$?

if [ $anygood -eq 0 ]
then
args=`echo $args|sed 's/%20/ /g'`
echo "No results found for $args"
exit 2
fi

$wget -nv -O - "http://en.wikipedia.org/wiki/${args}" 2>&1|sed -e :a -e 's/<[^>]*>/ /g;/</N;//ba'|sed -e '1,/Jump to:/d' -e '/^$/N;/\n$/N;//D' -e '/^.*[.*edit.*].*See also.*$/,$d' -e '/This *disambiguation *page/,$d' -e '/^$/N;/\n$/D'|$pager

exit 0

