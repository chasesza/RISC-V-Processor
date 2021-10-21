import re

inp = input()

src = open(inp+".asm", 'r')
machine_file = open(inp+".obj", 'w')
sim_file = open(inp+".txt", 'w')
coef_file = open(inp+".coe", 'w')
coef_file.write("memory_initialization_radix=2;\nmemory_initialization_vector=")

first = True
lines = src.readlines()
for line in lines:
    d = re.split("[, |,|\s| ]+", line)
    print(d)
    print("\n")
    s=''
    valid = True
    if d[0].lower() == "lui":
        machine_instruction = format(int(d[2], 10), "020b") #imm
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110111" #opcode
    elif d[0].lower() == "auipc":
        machine_instruction = format(int(d[2], 10), "020b") #imm
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010111" #opcode
    elif d[0].lower() == "jal":
        imm = format(int(d[2], 10), "021b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[20] + imm[1:11][::-1] + imm[11] + imm[12:20][::-1] #j-type
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "1101111" #opcode
    elif d[0].lower() == "jalr":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "1100111" #opcode
    elif d[0].lower() == "beq":
        imm = format(int(d[3], 10), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[12] + imm[5:11][::-1]  #b-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction += imm[1:4][::-1] + imm[11] #b-type
        machine_instruction += "1100011" #opcode
    elif d[0].lower() == "bne":
        imm = format(int(d[3], 10), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[12] + imm[5:11][::-1]  #b-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs1
        machine_instruction += "001" #func3
        machine_instruction += imm[1:4][::-1] + imm[11] #b-type
        machine_instruction += "1100011" #opcode
    elif d[0].lower() == "blt":
        imm = format(int(d[3], 10), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[12] + imm[5:11][::-1] #b-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs1
        machine_instruction += "100" #func3
        machine_instruction += imm[1:4][::-1] + imm[11] #b-type
        machine_instruction += "1100011" #opcode
    elif d[0].lower() == "bge":
        imm = format(int(d[3], 10), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[12] + imm[5:11][::-1]  #b-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs1
        machine_instruction += "101" #func3
        machine_instruction += imm[1:4][::-1] + imm[11] #b-type
        machine_instruction += "1100011" #opcode
    elif d[0].lower() == "bltu":
        imm = format(int(d[3], 10), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[12] + imm[5:11][::-1]  #b-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs1
        machine_instruction += "110" #func3
        machine_instruction += imm[1:4][::-1] + imm[11] #b-type
        machine_instruction += "1100011" #opcode
    elif d[0].lower() == "bgeu":
        imm = format(int(d[3], 10), "013b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[12] + imm[5:11][::-1]  #b-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs1
        machine_instruction += "111" #func3
        machine_instruction += imm[1:4][::-1] + imm[11] #b-type
        machine_instruction += "1100011" #opcode
    elif d[0].lower() == "lb":
        imm = format(int(d[2], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0000011" #opcode
    elif d[0].lower() == "lh":
        imm = format(int(d[2], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "001" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0000011" #opcode
    elif d[0].lower() == "lw":
        imm = format(int(d[2], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "010" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0000011" #opcode
    elif d[0].lower() == "lbu":
        imm = format(int(d[2], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "100" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0000011" #opcode
    elif d[0].lower() == "lhu":
        imm = format(int(d[2], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "101" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0000011" #opcode
    elif d[0].lower() == "sb":
        imm = format(int(d[2], 10), "012b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[5:][::-1] #s-type
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction +=imm[:5][::-1] #s-type
        machine_instruction += "0100011" #opcode
    elif d[0].lower() == "sh":
        imm = format(int(d[2], 10), "012b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[5:][::-1] #s-type
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "001" #func3
        s+=imm[:5][::-1] #s-type
        machine_instruction += "0100011" #opcode
    elif d[0].lower() == "sw":
        imm = format(int(d[2], 10), "012b") #imm
        imm = str(imm)[::-1] #reverse to make indices match
        machine_instruction = imm[5:][::-1] #s-type
        machine_instruction += format(int(d[1][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs1
        machine_instruction += "010" #func3
        machine_instruction +=imm[:5][::-1] #s-type
        machine_instruction += "0100011" #opcode
    elif d[0].lower() == "addi":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "slti":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "010" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "sltiu":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "011" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "xori":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "100" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "ori":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "110" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "andi":
        imm = format(int(d[3], 10), "012b") #imm
        machine_instruction = imm #i-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "111" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "slli":
        imm = format(int(d[3], 10), "05b") #imm
        machine_instruction = "0000000"
        machine_instruction += imm #r-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "001" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "srli":
        imm = format(int(d[3], 10), "05b") #imm
        machine_instruction = "0000000"
        machine_instruction += imm #r-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "101" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "srai":
        imm = format(int(d[3], 10), "05b") #imm
        machine_instruction = "0100000"
        machine_instruction += imm #r-type
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "101" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0010011" #opcode
    elif d[0].lower() == "add":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "sub":
        machine_instruction = "0100000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "000" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "sll":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "001" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "slt":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "010" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "sltu":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "011" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "xor":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "100" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "srl":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "101" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "sra":
        machine_instruction = "0100000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "101" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "or":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "110" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    elif d[0].lower() == "and":
        machine_instruction = "0000000"
        machine_instruction += format(int(d[3][1:], 10), "05b") #rs2
        machine_instruction += format(int(d[2][1:], 10), "05b") #rs1
        machine_instruction += "111" #func3
        machine_instruction += format(int(d[1][1:], 10), "05b") #rd
        machine_instruction += "0110011" #opcode
    else:
        valid = False
    if valid:
        if first:
            coef_file.write(machine_instruction)
            first = False
        else:
            coef_file.write(",\n" + machine_instruction)
        sim_file.write("\n\t\t//"+ line +"\t\t#2;\n\t\tinst = 32\'b" + machine_instruction + ";\n")
        machine_instruction += '\n'
        machine_file.write(machine_instruction)

coef_file.write(";\n")
coef_file.close()
machine_file.close()
sim_file.close()
src.close()