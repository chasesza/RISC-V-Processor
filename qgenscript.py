f = open("qgenerator.txt", 'w')

s1='q1(j) <='
s2='q2(j) <='

for i in range(31):
	s1 += ' OR ( s1_vec(' + str(i) + ') AND q_arr(' + str(i) + ')(j) )'
	s2 += ' OR ( s2_vec(' + str(i) + ') AND q_arr(' + str(i) + ')(j) )'

s1 += ';\n'
s2 += ';\n'

f.write(s1)
f.write(s2)

f.close()
	
