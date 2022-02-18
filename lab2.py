""" Fred Straub
CS 480L
Lab 2 - RSA Algorithm and Digital Signature
inspired by video lecture by Faramarz Mortezaie """

from Crypto.PublicKey import RSA
from Crypto.Signature.pkcs1_15 import PKCS115_SigScheme
from Crypto import Random
from Crypto.Hash import SHA256
import binascii

random_generator = Random.new().read

keyPair = RSA.generate(1024, random_generator)

msg = b'I have completed lab 2.'
hashA = SHA256.new(msg)

pubkey = keyPair.publickey()
n=(hex(keyPair.n))
e=(hex(keyPair.e))
d=(hex(keyPair.d))
print('\n The value of n is:', n, '\n')
print('The value of d is:', d, '\n')
print('The value of e is:', e, '\n')

print('The Public key is: (n=', n, '  e=', e, ')\n')
print('The Private key is: (n=', n, '  e=', d, ')\n')
signer = PKCS115_SigScheme(keyPair)
signature = signer.sign(hashA)

# You could print the signature.
#print("Signature:", binascii.hexlify(signature))

msg = b'I have completed lab 2.'
hashm = SHA256.new(msg)
verifirer = PKCS115_SigScheme(pubkey)

try:
    verifirer.verify(hashm, signature)
    print("Signature is valid.")
except:
    print("Signature is invalid.")