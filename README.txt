Instruções (16 bits):

Instrução       | Tipo | Opcode | func3 | func5 | Semântica
      	        |      |        |       |	|
li rd imm       |  A   |   00   |  ---  | 00000 | rd  = imm          
add rd rs1      |  B   |   01   |  000  | 00000 | rd  = rd + rs1          
dot rd rs1      |  B   |   01   |  000  | 00001 | rd  = R[rs1]*R[rd]+R[rs1+1]*R[rd+1]   
dota rs2 rd rs1 |  C   |   10   |  ---  | 00011 | rs2 = rs2 + R[rs1]*R[rd]+R[rs1+1]*R[rd+1]   

       
Formato dos campos:

Bit: 15  14 | 13  12  11  10  9 | 8  7  6 | 5  4  3 | 2  1  0
            |                   |         |         |
A:  opcode  |      funct5       |     imm(6 bits)   |    rd
B:  opcode  |      funct5       | funct3  |   rs1   |    rd            
C:  opcode  |      funct5       |   rs2   |   rs1   |    rd

Notas:
	- O hardware lê automaticamente o registo consecutivo de rd (R[rd+1]) e rs1 (R[rs1+1]) para poder realizar dot e dota. 
	Por isto em dota  o registo de destino deve ser rs2 e não rd. Rs2 não precisa de consecutivo.

	- funct3 é 000 em todas as instruções do tipo B pelo que é redundante, mas preferimos deixa-lo para extensibilidade futura.

	- Os 2 bits menos significativos de funct5 correspondem ao sinal de controlo da ALU:
		00: Soma
		01: dot
		11: dot + C
	
	- li apenas suporta imediatos de 6 bits com sinal (-32 ate 31)	

	- Quando o bit mais significativo do opcode é 1 então o registo em que se guardara o resultado da ALU ou o imediato é rs2 em vez de rd

	- O opcode funct5 e os registos têm de estar na mesma posição em diferentes tipos de instrução
	
	- O opcode também indica a fonte do dado a guardar: (Isto poderia gerar problemas pois uma instrução que deve guardar um imediato nunca poderia guardar o resultado em rs2)
		00: imediato
		XX: ALU
	


