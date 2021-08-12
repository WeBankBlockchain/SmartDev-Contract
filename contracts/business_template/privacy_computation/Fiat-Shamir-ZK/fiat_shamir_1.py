import sys
import random
import hashlib
import libnum

n=8269
password="Hello"
g= 11

v = random.randint(1,n)
c = random.randint(1,n)


print("Password:\t\t",password)
x = int(hashlib.md5(password.encode()).hexdigest()[:8], 16) % n
print("Password hash(x):\t",x,"\t (last 8 bits)")


y= pow(g,x,n)

t = pow(g,v,n)

r = (v - c * x) % (n-1)

Result = ( pow(g,r,n) * pow(y,c,n))  % n

print('\n======Phase 0: Agreed parameters============')
print('P=',n,'\t(Prime number)')
print('G=',g,'\t(Generator)')

print('\n======Phase 1: Peggy sends y to Victor,Victor store y with Peggy ==================')
print('y= g^x mod P=\t\t',y)

print('\n======Phase 2: Peggy wants to login , She send t to Victor==================')
print('v=',v,'\t(Peggy\'s random value)')
print('t=g**v % n =\t\t',t)

print('\n======Phase 3: Victor choose c randomly ,and sends it to Peggy==================')
print('c=',c,'\t(Vitor\' random challenge)')

print('\n======Phase 4: Peggy recieves c and calculate r=v-cx, sends r to Victor==================')
print('r=v-cx =\t\t',r)

print('\n======Phase 5: Victor calculates (g^r)*(y^c)== t? ==================')
print('t= % n =\t\t',t)
print('( (g**r) * (y**c) )=\t',Result)
if (t==Result):
	print('\nPeggy has proven she knows password')
else:
	print('\nPeggy has not proven she knows x')