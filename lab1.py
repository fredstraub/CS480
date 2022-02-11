from fileinput import close
import hashlib

#create three objects with different hashes
hashObj = hashlib.sha256()
hashObj2 = hashlib.sha512()
hashObj3 = hashlib.md5()

#read the file and append the objects with the bits
with open('test.txt', 'rb') as file:

    line = 0
    while line != b'':
        line = file.read(1024)
        hashObj.update(line)
        hashObj2.update(line)
        hashObj3.update(line)

#create the message digest for the objects
msgDigest = hashObj.hexdigest()
msgDigest2 = hashObj2.hexdigest()
msgDigest3 = hashObj3.hexdigest()

# print out the digests and their lengths
print('SHA256 is:',len(msgDigest), 'characters long and looks like this \n', msgDigest, 
'\nSHA512 is:',len(msgDigest2), 'characters long and looks like this \n', msgDigest2, 
'\nMD5 is:',len(msgDigest3), 'characters long and looks like this \n', msgDigest3)

file.close()