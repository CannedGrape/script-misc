#!/bin/bash

if [ ${#} -ne 3 ]; then
    echo "Usage: ${0} prefix suffix n"
    exit
fi

prefix=$1
suffix=$2
n=$3

echo "File prefix: $prefix"
echo "File suffix: $suffix"
echo "Pages: $n"

for (( i=1; i<=2*$n; i=i+1 ))
do
    idxS=`printf %03d ${i}`
    fileNameS="${prefix} ${idxS}.${suffix}"

    if [ $i -le $n ]; then
        let idxD=2*$i-1
    fi

    if [ $i -gt $n ]; then
        # 2(2n+1-i)
        let idxD=2*2*$n+2-2*$i
    fi
    
    idxD=`printf %03d ${idxD}`
    fileNameD="${prefix}_${idxD}.${suffix}"
    echo "${fileNameS}  --->  ${fileNameD}"
    mv "${fileNameS}" "${fileNameD}"
done
