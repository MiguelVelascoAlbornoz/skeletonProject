Instruções (16 bits):

li rd, imm          -> 00 (opcode)  (A-Type) (3 + 2 + 5 + 6) funct5
add rd, rs          -> 01 (opcode)  (B-Type) (3 + 3 + 2) funct5 + funct3
dot rd, rs          -> 01 (opcode)  (B-Type) (3 + 3 + 2) funct5 + funct3
dota rd, rs1, rs2   -> 10 (opcode)  (C-Type) (3 + 3 + 3 + 2) funct5

A-Type:
rd + imm + funct5 + opcode

B-Type:
rd + rs + funct3 + funct5 + opcode

C-Type:
rd + rs1 + rs2 + funct5 + opcode
