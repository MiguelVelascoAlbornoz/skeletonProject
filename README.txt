Instruções (16 bits):

li rd, imm          -> 00 (opcode)  (A-Type) (3 + 2 + 5 + 6) funct5 (00000)
add rd, rs          -> 01 (opcode)  (B-Type) (3 + 3 + 2) funct5 (00000) + funct3 (000)
dot rd, rs          -> 01 (opcode)  (B-Type) (3 + 3 + 2) funct5 (00000) + funct3 (001)
dota rd, rs1, rs2   -> 10 (opcode)  (C-Type) (3 + 3 + 3 + 2) funct5 (00000)

A-Type:
rd (0:2) + imm (3:8) +                  funct5 (9:13) + opcode (14:15)

B-Type:
rd (0:2) + rs1  (3:5) + funct3 (6:8) + funct5  (9:13) + opcode (14:15)

C-Type:
rd (0:2) + rs1 (3:5) + rs2      (6:8) + funct5  (9:13)+ opcode (14:15)

add rd, rs1 -> rd = rd + rs1
dot rd, rs1 -> rd = rs1[0]*rd[0]+rs1[1]*rd[1]
dota rs2, rd, rs1 ->rs2 = rs2 + rs1[0]*rd[0] + rs1[1]*rd[1]

Há dois registos dos quais sempre se obtém o seu consecutivo, rd e rs1. Por isso em dota o registo modificado é rs2 pois o registo consecutivo de rs2 não é calculado