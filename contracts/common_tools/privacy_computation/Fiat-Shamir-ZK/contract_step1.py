import libnum
import hashlib
n=8269
g=11

password = "Hello"

print("Password:\t\t",password)
x = int(hashlib.sha256(password.encode()).hexdigest()[:8], 16) % n
print("Password hash(x):\t",x,"\t (last 8 bits)")

print('\n======Phase 1: Peggy sends y to Victor,Victor store y as Peggy\' token==================')
y= pow(g,x,n)
print('y= g^x mod P=\t\t',y)