import libnum
import hashlib
import random
n=8269
g=11

v = random.randint(1,n)

print('\n======Phase 2: Peggy wants to login , She send t to Victor==================')
v = random.randint(1,n)
t = pow(g,v,n)
print('v=',v,'\t(Peggy\'s random value)')
print('t=g**v % n =\t\t',t)