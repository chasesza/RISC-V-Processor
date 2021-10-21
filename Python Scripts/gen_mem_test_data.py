f = open('testdata.txt', 'w')

for i in range(4096):
    s = format(i, "032b") + ',\n'
    f.write(s)
    print(s)
f.close()