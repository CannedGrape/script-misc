## 20210509


import os
import exifread

def replace_chars(n1):
    n2 = n1.replace(' ', '_')
    n2 = n2.replace('(', '_')
    n2 = n2.replace(')', '_')
    return n2


def getExif(filename):
    fieldName = 'EXIF DateTimeOriginal'

    fd = open(filename, 'rb')
    tags = exifread.process_file(fd)
    fd.close()

    filenameSuffixL = filename.split('.')
    filenameSuffix = filenameSuffixL[-1]

    if fieldName in tags:
        newNamePre = 'IMG_' + str(tags[fieldName]).replace(':', '').replace(
            ' ', '_') + '_' + str(filename.split('.')[0]) + '.' + filenameSuffix

        tot = 1
        while os.path.exists(newNamePre):
            newNamePre = 'IMG_'+str(tags[fieldName]).replace(':', '').replace(
                ' ', '_') + '_' + str(tot) + '_' + str(filename.split('.')[0]) + '.' + filenameSuffix
            tot += 1

        newName = newNamePre.split(".")[0] + '.' + filenameSuffix

        print("%s --> %s" % (filename, newName))
        os.rename(filename, newName)
    else:
        print('%s --> No %s found.' % (filename, fieldName))


def renameFile(filename):
    syscmd = 'exiftool -d "%Y%m%d_%H%M%S" -T -FileName -DateTimeOriginal -MediaCreateDate -GPSDateTime -ModifyDate -CreateDate -FileModifyDate ' + filename
    #tags = commonds.getstatusoutput(syscmd)
    tags = os.popen(syscmd)
    tags = tags.readlines()
    tag = tags[0]
    tag = tag.replace(':', '')
    tag = tag.replace('\n', '')
    tagc = tag.replace('-', '99999999999999')
    tagc = tagc.replace('00000000 000000', '99990000000000')
    tagc = tagc.replace('_', '')
    tagc = tagc.split('\t')
    tag = tag.split('\t')
    tagmin = int(min(tagc))
    tagi = tagc.index(min(tagc))
    # print(tag, tagmin, tag[tagi])
    filedate = tag[tagi]
    if (tagmin == 99999999999999 or tagmin == 99990000000000):
        syscmd = 'exiftool -d "%Y%m%d_%H%M%S" -T -FileModifyDate ' + filename
        tags = os.popen(syscmd)
        tags = tags.readlines()
        tag = tags[0]
        tag = tag.replace(':', '')
        tag = tag.replace('\n', '')
        tagc = tag.replace('-', '99999999999999')
        tagc = tagc.replace('00000000 000000', '99990000000000')
        tagc = tagc.replace('_', '')
        tagc = tagc.split('\t')
        tag = tag.split('\t')
        tagi = 0
        filedate = tag[tagi] + '_M'

    filenameSuffixL = filename.split('.')
    filenameSuffix = filenameSuffixL[-1]

    newName = 'IMG_' + str(filedate) + '.' + filenameSuffix

    tot = 1
    while os.path.exists(newName):
        newName = 'IMG_' + str(filedate) + '_' + \
            str(tot) + '.' + filenameSuffix
        tot += 1

    outstr = "[" + str(tagi) + "] " + filename + " --> " + newName
    print(outstr)
    print(outstr, file=logfp)
    os.rename(filename, newName)


do_not_proc_list = ['txt', 'log', 'sh', 'py', 'db']


def renameFileV2(tag, percentage):
    tag = tag.replace('\n', '')
    tag = tag.replace('0000:00:00 00:00:00', '-')
    tag = tag.replace(':', '')
    tag = tag.replace(' ', '')

    # tag_int = tag.replace('_', '')
    # tag_int = tag_int.split('\t')
    tag = tag.split('\t')

    filename = tag[0]
    filenameSuffixL = filename.split('.')
    filenameSuffix = filenameSuffixL[-1].lower()
    if filenameSuffix in do_not_proc_list:
        outstr = "[X] " + filename + " --> NOT_PROC" + \
            "  " + str(percentage) + "%"
        print(outstr)
        print(outstr, file=logfp)
        return

    for i in range(len(tag)):
        if i != 0 and tag[i] != '' and tag[i] != '-':
            if i == 1:
                filedate = tag[i] + '_O'
                break
            if i == 2:
                filedate = tag[i] + '_C'
                break
            if i == 3:
                filedate = tag[i] + '_G'
                break
            if i == 4:
                filedate = tag[i] + '_M'
                break
            if i == 5:
                filedate = tag[i] + '_C'
                break
            if i == 6:
                filedate = tag[i] + '_F'

    newName = 'IMG_' + str(filedate) + '_' + filename #+ '.' + filenameSuffix

    dup_cnt = 1
    while os.path.exists(newName):
        newName = 'IMG_' + str(filedate) + '_' + \
            str(dup_cnt) + '_' + filename # '.' + filenameSuffix
        dup_cnt += 1

    outstr = "[" + str(i) + "] " + filename + " --> " + \
        newName + "  " + str(percentage) + "%"
    print(outstr)
    print(outstr, file=logfp)
    os.rename(filename, newName)


# for filename in os.listdir('.'):
#     fileSuffixL = filename.split('.')
#     fileSuffix = fileSuffixL[-1]
#     if (fileSuffix == "log" or fileSuffix == "py"):
#         continue
#     # getExif(filename)
#     renameFile(filename)

for filepath, dirnames, filenames in os.walk(r'.'):
    for filename in filenames:
        file_path1 = os.path.join(filepath, filename)
        file_path2 = replace_chars(file_path1)
        print(file_path1, file_path2)
        os.rename(file_path1, file_path2)

logfp = open('rename.log', 'w')

syscmd = 'exiftool -d "%Y%m%d_%H%M%S" -T -FileName -DateTimeOriginal -MediaCreateDate -GPSDateTime -ModifyDate -CreateDate -FileModifyDate *'
tags = os.popen(syscmd)
tags_list = tags.readlines()
total = len(tags_list)
curri = 0
for tag in tags_list:
    curri += 1
    percentage = round(curri / total * 100, 2)
    renameFileV2(tag, percentage)

logfp.close()
