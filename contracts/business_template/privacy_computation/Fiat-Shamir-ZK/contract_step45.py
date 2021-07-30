import libnum
import hashlib
import random
n=8269
g=11

password = "Hello"
x = int(hashlib.sha256(password.encode()).hexdigest()[:8], 16) % n


print('\n======Phase 4: Peggy recieves c and calculate r=v-cx, sends r to Victor==================')
c = input("c= ")
v = input("v= ")
r = (int(v) - int(c) * x) % (n-1)

print('r=v-cx =\t\t',r)