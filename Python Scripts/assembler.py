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
    valid = True
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
    elif d[0].lower() == "jalr":
        imm = format(int(d[3], 16), "012b") #imm
        s = imm #i-type
        s += format(int(d[2][1:], 10), "05b") #rs1
        s += "000" #func3
        s += format(int(d[1][1:], 10), "05b") #rd
        s += "1100111" #opcode
    elif d[0].lower() == "beq":
        imm = format(int(d[3], 16), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        s = imm[12] + imm[5:11]  #b-type
        s += format(int(d[2][1:], 10), "05b") #rs2
        s += format(int(d[1][1:], 10), "05b") #rs1
        s += "000" #func3
        s += imm[1:4] + imm[11] #b-type
        s += "1100111" #opcode
    else:
        valid = False
    if valid:
        s += '\n'
        dest.write(s)

dest.close()
src.close()