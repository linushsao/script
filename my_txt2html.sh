#!/bin/bash
#

TARGET=$1
OUTPUT=$2
DIST="/tmp/tmp.html"

if [ ${TARGET} == "" ]; then
	echo "Wrong param,ex: <Target file>"
	exit 0
	elseif [ ${TARGET} == "help" ]; then
	echo "param: <Target file> <output file[optional]>"
	echo "if <output file> is null,default /tmp/tmp.html"
	exit 0
fi

if [ ${OUTPUT} != "" ]; then
	DIST=${OUTPUT}
fi

echo "" >/tmp/tmp.html
sed 's/</[/g' ${TARGET} > /tmp/output-a.txt
sed 's/>/]/g' /tmp/output-a.txt > /tmp/output1-a.txt

awk '{print $0, "<br>"}' /tmp/output1-a.txt > ${DIST}

