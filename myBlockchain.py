""" Fred Straub
CS 480L
Lab 3 - Blockchain First Part
inspired by video lecture by Faramarz Mortezaie """

from time import time

class Blockchain():
    
    # constructor
    def __init__(self):
        self.chain = []
        self.current_trasnactions = []

    def new_block(self, proof, previous_hash):
        block = {
        'index': len(self.chain) + 1,
        'timestamp': time(),
        'transactions': self,
        'proof': proof,
        'previous_hash': previous_hash, 
        }
        self.current_trasnactions = []

        self.chain.append(block)
        return block

    def new_transactions(self, sender, recipient, amount):
        self.current_trasnactions.append({'sender': sender, 'recipient': recipient, 'amount': amount})

    @staticmethod
    def hash(block):
        pass

    def last_block(self):
        pass
    
    
def main():
    print('Welcome to our Blockchain.')
    head = Blockchain()
    head.new_transactions('Jeff', 'Alice', 100)
    print(head.current_trasnactions)

main()