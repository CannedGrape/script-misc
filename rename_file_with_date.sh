#!/bin/bash
########################################################################################################################
# File Name : rename_file_with_date.sh
# Author    : CannedGrape
# Date      : 2016-12-25
# Function  : ʹ���ļ������������ļ���
# Parameters: 1 - pre_str
# Usage     :
# History   : ----------------------------------------------------------------------------------------------------------
# 2016-12-25    CannedGrape         1.0     Initial.
# 2017-01-08    CannedGrape         1.1     Improve Performance.
########################################################################################################################

# Parameters check
if [ $# -lt 1 ]
then
    echo "Usage:"
    echo "sh $0 pre_str"
    echo "    pre_str: Prefix of filename."
    exit
fi

pre_str=$1

cat a.txt | while read line
do
    # Improve Performance.
    # tmp_str0=`ls -l "${line}" --time-style="+%Y-%m-%d %H-%M-%S %N"`
    # tmp_str1=`echo ${tmp_str0} |cut -d " " -f 6`
    # tmp_str2=`echo ${tmp_str0} |cut -d " " -f 7`
    # tmp_str3=`echo ${tmp_str0} |cut -d " " -f 8`
    tmp_str0=(`ls -l "${line}" --time-style="+%Y%m%d %H%M%S %N"`)
    tmp_str1=${tmp_str0[5]}
    tmp_str2=${tmp_str0[6]}
    tmp_str3=${tmp_str0[7]}
    sub_str=`echo "${line}" |cut -d "." -f 2`

    tmp_str3=`expr $tmp_str3 + 0`
    tmp_str3=`printf "%09d" $tmp_str3`

    dst_filename="${pre_str}_${tmp_str1}_${tmp_str2}_${tmp_str3}".${sub_str}

    same_flag="D"
    if [ -f "$dst_filename" ]
    then
        same_flag="S"
        add_en=1
        while [ $add_en == 1 ]
        do
            tmp_str3=`expr $tmp_str3 + 1`
            tmp_str3=`printf "%09d" $tmp_str3`
            dst_filename="${pre_str}_${tmp_str1}_${tmp_str2}_${tmp_str3}".${sub_str}
            if [ -f "$dst_filename" ]
            then
                add_en=1
            else
                add_en=0
            fi
        done
    fi

    #     echo "[S]" "${line}" "-->" "${pre_str} ${tmp_str1} ${tmp_str2} ${tmp_str3}".${sub_str}
    #     mv "${line}" "${pre_str} ${tmp_str1} ${tmp_str2} ${tmp_str3}".${sub_str}
    # else
    #     echo "[D]" "${line}" "-->" "${pre_str} ${tmp_str1} ${tmp_str2} ${tmp_str3}".${sub_str}
    #     mv "${line}" "${pre_str} ${tmp_str1} ${tmp_str2} ${tmp_str3}".${sub_str}
    # fi
    echo "[${same_flag}]" "${line}" "-->" "${dst_filename}"
    mv "${line}" "${dst_filename}"

done
