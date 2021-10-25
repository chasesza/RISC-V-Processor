lui     x2,     8               ;0   
addi    x2,     x2,     1       ;4      builds button/sw register address
lui     x3,     12              ;8    
addi    x3,     x3,     1       ;12     builds led register address

addi    x9,     x10,    0       ;16     store x10 in x9
lw      x10,    x2,     0       ;20     gets data from button/sw, stores in x10
andi    x10,    x10,    3       ;24     bitwise AND that zeros all buttons/switches except button 0 and button 1
xori    x8,     x9,     3       ;28     invert bits 0 and 1 of x9 and store in x8
and     x8,     x8,     x10     ;32     the bits in x8 are only one if they were one this cycle and 0 last cycle (detects rising edge)
beq     x8,     x0, 4294967276  ;36     go back to instruction address 16 if there is no rising edge

srli    x8,     x8,     1       ;40     shift right by one to isolate button 1
beq     x8,     x0,     12      ;44     if button 0 was pressed, go to addition (instruction address 56)
addi    x11,    x11  4294967295 ;48     if button 1 was pressed, subtract 1 from x11
jal     x0,     8               ;52     skip the next instruction
addi    x11,    x11     1       ;56     if button 0 was pressed, add 1 to x11

sw      x11,     x3,     0      ;60     stores data from x11 in the led reg
jal     x0,     4294967248      ;64     jump to instruction 16
