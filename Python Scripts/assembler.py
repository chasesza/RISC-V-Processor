import re

inp = input()
src_name = inp.split()[0]
dest_name = inp.split()[1]

src = open(src_name, 'r')
dest = open(dest_name, 'w')

lines = src.readlines()
for line in lines:
    d = re.split(", |,| ", line)
    s=''
    if d[0].lower() == "lui":
        s = format(int(d[2], 16), "020b") #imm
        s += format(int(d[1][1:], 10), "05b") #rd
        s += "0110111" #opcode
    elif d[0].lower() == "auipc":
        s = format(int(d[2], 16), "020b") #imm
        s += format(int(d[1][1:], 10), "05b") #rd
        s += "0010111" #opcode
    elif d[0].lower() == "jal":
        imm = format(int(d[2], 16), "021b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        s = imm[20] + imm[1:11][::-1] + imm[11] + imm[12:20][::-1] #j-type
        s += format(int(d[1][1:], 10), "05b") #rd
        s += "1101111" #opcode
    s += '\n'
    dest.write(s)

dest.close()
src.close()