lui     x2,     8               ;0   
addi    x2,     x2,     1       ;4      builds button/sw register address
lui     x3,     12              ;8    
addi    x3,     x3,     1       ;c      builds led register address
lw      x4,     x2,     0       ;10     gets data from button/sw, stores in x4
srai    x5,     x4,     4       ;14     shift data right by 4 to get switches and store in x5
andi    x4,     x4,     15      ;18     bitwise and by 0xF to get buttons and store in x4
add     x6,     x4,     x5      ;1c     add buttons and switches and store in x6
sw      x6,     x0,     1       ;20     stores data from x6 in block ram address 1
lw      x7,     x0,     1       ;24     loads data from block ram address 1 to  x7, note that this store/load is solely for testing purposes
sw      x7,     x3,     0       ;28     stores data from x7 in the led reg
jal     x0,     4294967268      ;2c     decrement pc by 28, discard link register
