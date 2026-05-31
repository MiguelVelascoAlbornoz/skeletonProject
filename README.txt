Instruções (16 bits):

li rd, imm          -> 00 (opcode)  (A-Type) (3 + 2 + 5 + 6) funct5
add rd, rs          -> 01 (opcode)  (B-Type) (3 + 3 + 2) funct5 + funct3
dot rd, rs          -> 01 (opcode)  (B-Type) (3 + 3 + 2) funct5 + funct3
dota rd, rs1, rs2   -> 10 (opcode)  (C-Type) (3 + 3 + 3 + 2) funct5

A-Type:
rd (0:2) + imm (3:8) +                funct5 (9:13) + opcode (14:16)

B-Type:
rd (0:2) + rs  (3:5) + funct3 (6:8) + funct5  (9:13) + opcode (14:16)

C-Type:
rd (0:2) + rs1 (3:5) + rs2    (6:8) + funct5  (9:13)+ opcode (14:16)
