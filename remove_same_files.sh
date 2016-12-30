#!/bin/bash
########################################################################################################################
# File Name : remove_same_file.sh
# Author    : CannedGrape
# Date      : 2016-12-25
# Function  : If the MD5 and SHA1 checksum of file_X in dst_dir is same as file_Y's in src_dir,
#             file_X will be deleted from dst_dir.
#             Use MD5 and SHA1 checksum.
# Parameters: 1 - src_dir
#             2 - dst_dir
#             3 - build_hash_list? (Y/N)
#             4 - hash_list_name
# Usage     : src_dir: source directory, read only.
#             dst_dir: destination directory, the same file will be deleted from dst_dir.
#             build_hash_list: Y/N
#             hash_list_name(optional): if build_hash_list == N, this parameter is required.
# History   : ----------------------------------------------------------------------------------------------------------
# 2016-12-25    CannedGrape         1.0     Initial.
########################################################################################################################

# Parameters check
if [ $# -lt 3 ]
then
    echo "Usage:"
    echo "sh $0 src_dir dst_dir build_hash_list [hash_list_name]"
    echo "    src_dir: source directory, read only."
    echo "    dst_dir: destination directory, the same file will be deleted from dst_dir."
    echo "    build_hash_list: Y/N"
    echo "    hash_list_name(optional): if build_hash_list == N, this parameter is required."
    exit
fi

################################################################################
# echo -e "Preparing...\c"
echo "Preparing..."

src_dir="$1"
dst_dir="$2"
build_src_hash_list="$3"
given_src_hash_list="$4"

if [ ${build_src_hash_list} == "Y" ]
then
    src_list_file="___src_list___"

    if [ $# == 3 ]
    then
        src_hash_file="___src_hash___"
        echo "Missing given_src_hash_list, use default settings..."
    else
        src_hash_file=${given_src_hash_list}
    fi

    if [ -f ${src_list_file} ]
    then
        rm -f ${src_list_file}
    fi

    if [ -f ${src_hash_file} ]
    then
        rm -f ${src_hash_file}
    fi

    touch ${src_list_file}
    touch ${src_hash_file}

    ls "${src_dir}" >${src_list_file}
else
    if [ $# == 3 ]
    then
        echo "Missing parameters..."
        exit
    else
        src_hash_file=${given_src_hash_list}
    fi
fi

##
dst_list_file="___dst_list___"
# dst_hash_file="___dst_hash___"

if [ -f ${dst_list_file} ]
then
    rm -f ${dst_list_file}
fi

# if [ -f ${dst_hash_file} ]
# then
#     rm -f ${dst_hash_file}
# fi

touch ${dst_list_file}
# touch ${dst_hash_file}


ls "${dst_dir}" >${dst_list_file}
echo "done"

################################################################################
if [ ${build_src_hash_list} == "Y" ]
then
    echo -e "Buliding HASH list...\c"
    cat ${src_list_file} | while read line
    do
        md5sum  "${src_dir}"/"${line}" >>${src_hash_file}
        sha1sum "${src_dir}"/"${line}" >>${src_hash_file}
    done

    echo "done"
fi

################################################################################
echo "Finding same file & Cleaning..."

cat ${dst_list_file} | while read line
do
    tmp_str=`md5sum "${dst_dir}"/"${line}"`
    tmp_str=`echo ${tmp_str} |cut -d " " -f 1`
    rst_str=`cat ${src_hash_file} |grep ${tmp_str}`
    if [ -n "${rst_str}" ]
    then
        echo "${dst_dir}/${line} and ${rst_str} MD5 Match!"

        tmp_str=`sha1sum "${dst_dir}"/"${line}"`
        tmp_str=`echo ${tmp_str} |cut -d " " -f 1`
        rst_str=`cat ${src_hash_file} |grep ${tmp_str}`

        if [ -n "${rst_str}" ]
        then
            echo "${dst_dir}/${line} and ${rst_str} SHA1 Match!"
            echo "Remove File: ${dst_dir}/${line}"
            rm -f "${dst_dir}"/"${line}"
        fi
    fi
done

################################################################################
echo -e "Final Cleaning...\c"
# rm -f $src_list_file
# rm -f $src_hash_file
# rm -f $dst_list_file
# rm -f $dst_hash_file
# echo "done"
echo "NOT EXCUTED..."

