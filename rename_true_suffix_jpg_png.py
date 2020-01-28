import os
import struct

files = os.listdir('./')

fileNum = len(files) - 1

for i in range(0, fileNum):
    # print(files[i])
    fd = open(files[i], "rb")
    head = struct.unpack("i", fd.read(4))[0]
    fd.close()
    if head == 1196314761:
        os.rename(files[i], files[i]+'.png')
