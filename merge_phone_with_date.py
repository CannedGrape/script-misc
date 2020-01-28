import os
import exifread
import string

imgList = []
dscList = []
imgTime = []
dscTime = []


def GetExifDateTime(filename):
    fieldName = 'EXIF DateTimeOriginal'

    fd = open(filename, 'rb')
    tags = exifread.process_file(fd)
    fd.close()

    if fieldName in tags:
        dateTimeStr = str(tags[fieldName]).replace(':', '').replace(' ', '_')
    else:
        dateTimeStr = "99999999_999999"

    return dateTimeStr


# main
print("scanning files ...")
for filename in os.listdir('.'):
    dscOnly = True
    if (filename.split('_')[0] == 'DSC'):
        for x in filename.split('_'):
            if x == 'IMG':
                dscOnly = False
                break
        if dscOnly == True:
            dscList.append(filename)
    if (filename.split('_')[0] == 'IMG'):
        imgList.append(filename)

print("processing ...")
dscLen = len(dscList)
dscList.append('DSC_9999.JPG')
dscStart = 0
for img in imgList:

    #dateStr = GetExifDateTime(img)
    # if dateStr == "99999999_999999":
    #    continue
    dateStr = img.split('.')[0]
    dateStr = dateStr.replace('IMG_', '')
    dateIntStr = dateStr.replace('_', '')
    dateInt = int(dateIntStr)
    while dateInt > 99999999999999:
        dateInt = dateInt // 10
    #dateInt = dateInt + 10000

    for i in range(dscStart, dscLen):
        dscDateStr = GetExifDateTime(dscList[i])
        dscDateIntStr = dscDateStr.replace('_', '')
        dscDateInt = int(dscDateIntStr)
        if i == dscStart:
            dscDateIntHis = dscDateInt
        if i == dscStart and dateInt <= dscDateInt:
            break

        if i == dscLen - 1 and dateInt >= dscDateInt:
            i = dscLen
            break

        if dateInt >= dscDateIntHis and dateInt <= dscDateInt:
            dscStart = i
            break
        dscDateIntHis = dscDateInt

    newName = dscList[i].split('.')[0] + '(' + img

    print("%s --> %s" % (img, newName))
    os.rename(img, newName)
