""" Fred Straub
CS 480L
Lab 2 - RSA Algorithm and Digital Signature """

import Crypto
from Crypto.Util import number
import random
from time import time

random.seed(time)

# need two large prime ints (p adn q)
a = random.randint(100, 1000)
b = random.randint(100, 1000)
 

p = number.getPrime(a)
q = number.getPrime(b)

n = p * q
z = (p-1)*(q-1)

# e = random number 1 < e < z
e = random.randrange(1,z)

# d = e -1 mod(p-1)(q-1)
d = e - 1%(p-1)*(q-1)

private_key = (n,d)
public_key = (n,e)

print('The Public Key is: %s' %(public_key,))
print('The Private Key is: %s' %(private_key,))