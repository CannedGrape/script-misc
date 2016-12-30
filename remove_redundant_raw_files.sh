#!/bin/bash
########################################################################################################################
# File Name : remove_redundant_raw_files.sh
# Author    : CannedGrape
# Date      : 2016-12-25
# Function  : Remove redundant raw(.NEF for Nikon) files.
# Parameters: 1 - jpg_dir: JPG Files
# Usage     : Please put all raw files into <jpg_dir>.raw.
#             This script will create folder <jpg_dir>.raw/del, then move redundant raw files to <jpg_dir>.raw/del.
# History   : ----------------------------------------------------------------------------------------------------------
# 2016-12-25    CannedGrape         1.0     Initial.
########################################################################################################################

# Parameters check
if [ $# -lt 1 ]
then
    echo "Usage:"
    echo "sh $0 jpg_dir"
    exit
fi
jpg_dir=$1

raw_dir="${jpg_dir}.raw"

nef_str=(`ls $raw_dir |grep NEF`)
nef_str_len=${#nef_str[*]}
echo "Total files: $nef_str_len"

raw_del_dir="${raw_dir}/del"
mkdir "${raw_del_dir}"

for (( i = 0; i < nef_str_len; i++ ))
do
    jpg_str=`echo "${nef_str[$i]}" |sed 's/NEF/JPG/g'`
    # echo "${nef_str[$i]} $jpg_str"

    if [[ ! -f "${jpg_dir}/${jpg_str}" ]]
    then
        echo "move file ${raw_dir}/${nef_str[$i]} to ${raw_del_dir}"
        mv ${raw_dir}/${nef_str[$i]} ${raw_del_dir}
    fi
done
