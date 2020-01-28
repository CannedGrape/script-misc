import os
import exifread


def getExif(filename):
    fieldName = 'EXIF DateTimeOriginal'

    fd = open(filename, 'rb')
    tags = exifread.process_file(fd)
    fd.close()

    filenameSuffixL = filename.split('.')
    filenameSuffix = filenameSuffixL[-1]

    if fieldName in tags:
        newNamePre = 'IMG_' + str(tags[fieldName]).replace(':', '').replace(
            ' ', '_') + '.' + filenameSuffix

        tot = 1
        while os.path.exists(newNamePre):
            newNamePre = 'IMG_'+str(tags[fieldName]).replace(':', '').replace(
                ' ', '_') + '_' + str(tot) + '.' + filenameSuffix
            tot += 1

        newName = newNamePre.split(".")[0] + '.' + filenameSuffix

        print("%s --> %s" % (filename, newName))
        os.rename(filename, newName)
    else:
        print('%s --> No %s found.' % (filename, fieldName))


for filename in os.listdir('.'):
    getExif(filename)
