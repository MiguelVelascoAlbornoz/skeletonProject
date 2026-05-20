###########################################################################
# Upper bound constants for static memory reservation
###########################################################################
.equ CONST_DIMENSION 4 #Tamanho matrizes 4 colunas
.equ CONST_BUFFER_SIZE 1024 #Nr bytes de cada ficheiro
.equ CONST_MAX_VOCAB_TOKENS 100 #Nr palavras vocabulario
.equ CONST_MAX_INPUT_TOKENS 10 # nr palavras ficheiro input

###########################################################################
# System call constants
###########################################################################
.equ CONST_SYSCALL_PRINT_INT 1
.equ CONST_SYSCALL_PRINT_STRING 4
.equ CONST_SYSCALL_PRINT_CHAR 11
.equ CONST_SYSCALL_EXIT 10
.equ CONST_SYSCALL_EXIT2 93
.equ CONST_SYSCALL_OPEN 1024
.equ CONST_SYSCALL_CLOSE 57
.equ CONST_SYSCALL_READ 63
.equ CONST_SYSCALL_WRITE 64

###########################################################################
# ASCII character constants
###########################################################################
.equ CONST_CHAR_EOF 0
.equ CONST_CHAR_SPACE 32
.equ CONST_CHAR_NEWLINE 10
.equ CONST_CHAR_HYPHEN 45
.equ CONST_CHAR_ZERO 48

###########################################################################
# Read flag constants
###########################################################################
.equ CONST_READ_ONLY 0
.equ CONST_WRITE_ONLY_CREATE 1
.equ CONST_WRITE_ONLY_CREATE_AND_APPEND 9

.data
###########################################################################
# Data section with static memory reservations.
# Feel free to add more if needed.
###########################################################################
VOCABULARY_FILENAME:     .string "C:/Users/migue/Downloads/Aulas/IAC/skeletonProject/vocab.txt"
EMBEDDINGS_FILENAME:     .string "C:/Users/migue/Downloads/Aulas/IAC/skeletonProject/embeddings.txt"
INPUT_FILENAME:          .string "C:/Users/migue/Downloads/Aulas/IAC/skeletonProject/input.txt"

W_Q_FILENAME:            .string "W_Q.txt"
W_K_FILENAME:            .string "W_K.txt"
W_V_FILENAME:            .string "W_V.txt"
.align 2
VOCAB_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the vocabulary file
INPUT_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the input file
MATRIX_BUFFER:           .zero CONST_BUFFER_SIZE                              # Contents of a matrix file (used for W_Q, W_K, W_V, and embeddings)

INPUT_INDICES_VECTOR:    .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of input token indices (#inputs x 4 bytes)
SCORES_VECTOR:           .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of scores (#tokens x 4 bytes)

INPUT_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the input
VOCAB_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the vocabulary

VOCAB_EMBEDDINGS_MATRIX: .zero (CONST_MAX_VOCAB_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
INPUT_EMBEDDINGS_MATRIX: .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
W_Q_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_Q matrix (dimension x dimension x 4 bytes)
W_K_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_K matrix (dimension x dimension x 4 bytes)
W_V_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_V matrix (dimension x dimension x 4 bytes)
Q_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Q matrix (#tokens x dimension x 4 bytes)
K_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # K matrix (#tokens x dimension x 4 bytes)
V_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # V matrix (#tokens x dimension x 4 bytes)

.text
main:

    ###########################################################################
    # Read vocabulary
    ###########################################################################
    la a0, VOCABULARY_FILENAME
    la a1, VOCAB_BUFFER
    li a2, CONST_BUFFER_SIZE
    
    jal read_file

    ###########################################################################
    # Read input
    ###########################################################################
    la a0, INPUT_FILENAME
    la a1, INPUT_BUFFER
    li a2, CONST_BUFFER_SIZE
    
    jal read_file

    ###########################################################################
    # Read W_Q matrix
    ###########################################################################
    la a0, W_Q_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    
    jal read_file

    ###########################################################################
    # Parse W_Q matrix from buffer
    ###########################################################################
    la a0, W_Q_MATRIX
    la a1, MATRIX_BUFFER

    jal parse_matrix_buffer

    ###########################################################################
    # Read W_K matrix
    ###########################################################################
    la a0, W_K_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    
    jal read_file

    ###########################################################################
    # Parse W_K matrix from buffer
    ###########################################################################
    la a0, W_K_MATRIX
    la a1, MATRIX_BUFFER

    jal parse_matrix_buffer

    ###########################################################################
    # Read W_V matrix
    ###########################################################################
    la a0, W_V_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    
    jal read_file

    ###########################################################################
    # Parse W_V matrix from buffer
    ###########################################################################
    la a0, W_V_MATRIX
    la a1, MATRIX_BUFFER

    jal parse_matrix_buffer

    ###########################################################################
    # Read embeddings matrix
    ###########################################################################
    la a0, EMBEDDINGS_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    
    jal read_file

    ###########################################################################
    # Parse vocabulary embeddings matrix from buffer
    ###########################################################################
    la a0, VOCAB_EMBEDDINGS_MATRIX
    la a1, MATRIX_BUFFER

    jal parse_matrix_buffer
    la t0, VOCAB_TOTAL_TOKENS
    sw a1, 0(t0)
    ###########################################################################
    # Convert input tokens to indices
    ###########################################################################
    la a0, INPUT_INDICES_VECTOR
    la a2, INPUT_BUFFER
    la a3, VOCAB_BUFFER
    jal tokens_to_indices
    
    la a0 INPUT_TOTAL_TOKENS
    sw a1 0(a0)
    mv s0, a1 # s0 <- matrix row amount

    ###########################################################################
    # Build input embeddings matrix
    ###########################################################################
    # TODO

    ###########################################################################
    # Build matrix Q
    ###########################################################################
    # TODO

    ###########################################################################
    # Build matrix K
    ###########################################################################
    # TODO

    ###########################################################################
    # Build matrix V
    ###########################################################################
    # TODO

    ###########################################################################
    # Compute scores for the last input token
    ###########################################################################
    la a0, SCORES_VECTOR
    la a1, W_Q_MATRIX
    la a2, W_K_MATRIX
    mv a3, s0
    lw a4, CONST_DIMENSION
    la a5, SCORES_VECTOR
    
    jal compute_scores
    

    ###########################################################################
    # Get the highest score index using argmax
    ###########################################################################
    # TODO

    ###########################################################################
    # Select chosen vector in V using the index from argmax
    ###########################################################################
    # TODO

    ###########################################################################
    # Pick the next token in the vocabulary with the highest score
    ###########################################################################
    # TODO


    #debug things
    la a0 VOCAB_BUFFER 
    jal print_vocabulary
    
    la a0 INPUT_BUFFER
    jal print_input
    
    la a0 INPUT_INDICES_VECTOR
    la a1 INPUT_TOTAL_TOKENS
    lw a1 0(a1)
    jal print_indices
    ###########################################################################
    # Terminate program successfully
    ###########################################################################
    li a0, 0
    j exit_with_code                                # Exit with code 0

# Read from a text file into a buffer.
# (in)     a0: filename address (char*)
# (in/out) a1: destination buffer
# (in)     a2: maximum number of bytes to read
read_file:
    addi sp sp -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    
    mv s0, a1 
    mv s1, a2 
    
    li a1, CONST_READ_ONLY
    li a7, CONST_SYSCALL_OPEN
    ecall # open file and move file descriptor to a0
    
    #a0 -> file descriptor
    mv a1, s0
    mv a2, s1
    mv s0 a0
    
    li a7, CONST_SYSCALL_READ
    ecall # read from file to buffer
    
    li a7, CONST_SYSCALL_CLOSE
    mv a0 s0
    ecall
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp sp 12
    # print buffer (for testing)
    #mv a0, a1
    #li a7, CONST_SYSCALL_PRINT_STRING
    #ecall
    
    ret

# Assumes the matrix is stored in the buffer as space-separated integers.
# Assumes columns are separated by 1 space (' '), and rows by 1 newline ('\n').
# Assumes only signed integers are provided.
# (in/out) a0: address of the matrix to fill (int*)
# (out)    a1: number of rows in the matrix (int)
# (in)     a1: address of the buffer containing the matrix data (char*)
parse_matrix_buffer:
    addi sp, sp, -4
    sw s0, 0(sp)
    mv s0, a1
    li t3, 1 #Contador de linhas
    li t4, 0 #Registo para n>9
    li t5, 1 #Sinal do número
    parse_matrix_buffer_loop:
        lb t0, 0(s0) # Carrega um elemento do buffer 
        beq t0, CONST_CHAR_EOF, parse_matrix_buffer_end # Fim da matriz
        beq t0, CONST_CHAR_SPACE, parse_matrix_buffer_Novo_Numero # Nova coluna
        beq t0, CONST_CHAR_NEWLINE, parse_matrix_buffer_Nova_Linha # Mudança de linha
        beq t0, CONST_CHAR_HYPHEN, parse_matrix_buffer_Mudanca_Sinal # Números negativos
        addi t0, t0, -CONST_CHAR_ZERO
        mul t4, t4, 10 #Cálculo de n>9
        addi t4, t4, t0
        addi s0, s0, 1
        j parse_matrix_buffer_loop
    parse_matrix_buffer_Novo_Numero: # Este if faz o cálculo de um novo número, após encontrar um espaço.
        mul t4, t4, t5 # Muda o sinal do número de acordo com o temporário de sinal t5.
        sw t4, 0(a0) # Guarda o valor na matriz de retorno.
        addi a0, a0, 4 # Avança a matriz de retorno
        mv t4, x0 # Reinicia a soma
        addi s0, s0, 1 # Avança o buffer de valores.
        li t5, 1 # Reinicia o sinal.
        j parse_matrix_buffer_loop
    parse_matrix_buffer_Nova_Linha:
        mul t4, t4, t5 # Mesma lógica de Novo_Número.
        sw t4, 0(a0)
        addi a0, a0, 4
        mv t4, x0
        addi s0, s0, 1
        addi t3, t3, 1 # Avança o contador de linhas.
        li t5, 1
        j parse_matrix_buffer_loop
    parse_matrix_buffer_Mudanca_Sinal:
        li t5, -1 # Marca o sinal como negativo.
        addi s0, s0, 1
        j parse_matrix_buffer_loop
    parse_matrix_buffer_end:
        mv a1, t3 # Move o número de linhas para a1.
        mul t4, t4, t5 # Mesma lógica de Novo_Número.
        sw t4, 0(a0)
        mv t4, x0
        lw s0, 0(sp)
        addi sp, sp, 4
        jr ra # Retorna à chamada.

    

# Converts the input tokens into their corresponding indices in the vocabulary.
# (in/out) a0: address of input indices vector to fill (int*)
# (out)    a1: size of input indices vector (number of tokens in input)
# (in)     a2: address to input buffer
# (in)     a3: address to vocabulary buffer
tokens_to_indices:
    #Inicialização
    mv t0 a0
    mv t1 a2
    mv t2 a3
    mv t6 t1
    li a4 0
    li a1 0
    li a5 CONST_CHAR_NEWLINE
    li a6 CONST_CHAR_EOF
    #t0 -> pointer to actual index to put the index
    #t1 -> pointer to actualInputChar of input buffer
    #t2 -> pointer to actualVocabChar of vocab buffer
    #t6 -> pointer to actualWorld of input buffer
    #t3 -> actual input char
    #t4 -> actual vocab char
    #a4 -> nr da palavra a inserir
    #a1 -> nr de palavras no input
    tokens_while:
        lbu t3 0(t1) 
        lbu t4 0(t2) 
         
        beq t3 a6 tokens_while_end #t3 == '\0' (*inputChar == EOF)
        
        #Comparar o carater atual do input e do vocabulario
        beq t3 t4 tokens_equal # t3 == t4 (*inputChar == *vocabChar)
        
        tokens_diferent:
            beq t4 a5 tokens_diferent_vocab_end_of_line #t4 == '\n' (*vocabChar == '\n')
            
            beq t4 a6 tokens_diferent_vocab_eof #t4 == EOF (*vocabChar == '\0')
            
            tokens_loop:
                beq t4 a5 tokens_loop_end #t4 == '\n' (*vocabChar == '\n')
                addi t2 t2 1 #vocabChar++(pointer) 
                lbu t4 0(t2)
                j tokens_loop
            
            tokens_loop_end:
                addi t2 t2 1
                mv t1 t6
                addi a4 a4 1
                j tokens_while
                
            tokens_diferent_vocab_eof:
                beq t3 a5 actual_end_of_line #t3 == '\n' (*inputChar == '\n')
                j tokens_while
            
            tokens_diferent_vocab_end_of_line:
                addi t2 t2 1 #vocabChar(pointer) passa ao siguiente caracter
                mv t1 t6 #inputChar(pointer) restaura-se ao inicio da palavra
                addi a4 a4 1 #contador do indice aumenta
                j tokens_while #volta ao inicio do while
                
        tokens_equal:
            beq t3 a5 actual_end_of_line #t3 == '\n' (*inputChar == new line)
            
            addi t1 t1 1 #seguinte caracter no inputChar(pointer)
            addi t2 t2 1 #eguinte caracter no vocabChar(pointer)
            j tokens_while
        
            actual_end_of_line:
                sw a4 0(t0) #guardar o indice 
                li a4 0 #contador de indices volta a 0
                addi t0 t0 4 #actualIndex++ #pointer em que se guardara o proximo indice
                addi a1 a1 1 #tamanho aumenta
                mv t2 a3 #vocabChar aponta ao inicio do buffer do vocabulario
                addi t1 t1 1 #inputChar++(pointer) avança ao proximo elemento
                mv t6 t1 #actualiza a palavra atual
                j tokens_while
        
    tokens_while_end:
         ret


# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the vocabulary embeddings matrix (int*)
# (in)     a2: address of the input indices array (int*)
# (in)     a3: number of tokens in the input (int)
build_input_embeddings_matrix:
    li t0 0 #iterador i
    li a4 CONST_DIMENSION
    build_input_while:
        bge t0 a3 build_input_while_end #if (i >= nTokens) break while
        
        lw t1 0(a2) # t1(indice) = *indicesArray
        
        mul t1 t1 a4 #indice *= CONST_DIMENSION
        slli t1 t1 2 #indice *= 4
        add t1 t1 a1 #t1(embedding adress) = embeddingsMatrix+indice
        
        li t3 0 #iterador j
        
        build_input_while_2:
            bge t3 a4 build_input_while_2_end # j >= CONST_DIMENSION
            lw t2 0(t1) #load embedding t2 = *ambeddingAdress
            sw t2 0(a0) #save embedding *a0 = t2
            addi t3 t3 1 # j++
            addi t1 t1 4 # embeddingAdress += 4
            addi a0 a0 4 # outputMatrix += 4
            j build_input_while_2
            
        build_input_while_2_end:
        
        addi t0 t0 1 #++i
        addi a2 a2 4 #indicesArray*=4
        j build_input_while
        
    build_input_while_end:
        ret

# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the first matrix (int*)
# (in)     a2: #rows of the first matrix (int)
# (in)     a3: #columns of the first matrix (int)
# (in)     a4: address of the second matrix (int*)
# (in)     a5: #rows of the second matrix (int)
# (in)     a6: #columns of the second matrix (int)
matrix_multiply:
     li t0, 0 # índice i 
    matrix_multiply_first_loop:
        beq t0, a2, matrix_multiply_end  
        li t1, 0 # índice j 
        matrix_multiply_second_loop:
            beq t1, a6, matrix_multiply_mudança_linha
            li t2, 0 # índice k
            li t3, 0 # soma_total        
            matrix_multiply_third_loop:
                beq t2, a3, matrix_multiply_mudança_coluna # Quando o k alcança o número de colunas.
                mul t4, t0, a3 # (i * colunas a), indica o avanço através das linhas.
                addi t4, t4, t2 # (t4 + K), indica o avanço através das colunas.
                slli t4, t4, 2 # Conversão em bits.
                add t4, t4, a1 # Adicionar ao endereço.
                lw t5, 0(t4) # Load do valor.
                mul t6, t2, a6 # (k * colunas b), indica o avanço através das linhas.
                addi t6, t6, t1 # (t4 + j), indica o avanço através das colunas.
                slli t6, t6, 2 # Mesmo lógica de A.
                add t6, t6, a4
                lw t6, 0(t6)
                mul t5, t5, t6
                add t3, t3, t5 # Armazenar o resultado da multiplicação em t3.
                addi t2, t2, 1 # Incrementar o k.
                j matrix_multiply_third_loop
            matrix_multiply_mudança_coluna:
                mul t4, t0, a6 # (i * número colunas A), escolhe qual linha da matriz de output se seleciona.
                add t4, t4, t1 # (t4 + j), avança através da linha da matriz de output de acordo com o j, com o segundo ciclo.
                slli t4, t4, 2 # Conversão em bits.
                add t4, t4, a0 # Adicionar ao endereço.
                sw t3, 0(t4) # Load do valor.
                addi t1, t1, 1 # Incrementar o j.
                j matrix_multiply_second_loop
        matrix_multiply_mudança_linha:
            addi t0, t0, 1 # Incrementar o i.
            j matrix_multiply_first_loop
    matrix_multiply_end:
        jr ra # Retorno à chamada.




# (in/out) a0: address of the output scores vector to fill (int*)
# (in)     a1: address of Q matrix (int*)
# (in)     a2: address of K matrix (int*)
# (in)     a3: #rows of Q and K (int)
# (in)     a4: #columns of Q and K (int)
# (in)     a5: target token index for which we want to compute the score (int)
compute_scores:
    slli t0, a4, 2 # t0 <- col amount * 4
    mul a5, t0, a5 
    
    addi, sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    
    mv s0, a0 # s0 <- address of the current ouput score in output score vector (int*)
    add s1, a1, a5 # s1 <- address of target in Q matrix (int*)
    mv s2, a2 # s2 <- address of current vector in K matrix (int*)
    mv s3, a3 # s3 <- row amount
    mv s4, a4 # s4 <- column amount
    
    score_loop:
    beqz s3, score_end
    mv a1, s1 # a1 <- address of first vector (int*)
    mv a2, s2 # a2 <- adress of second vector (int*)
    mv a3, s4 # a3 <- length of the vectors (int)
    
    jal ra, dot
    sw a1, 0(s0) # move dot product to output score vector
    
    addi s0, s0, 4
    slli t0, s4, 2 # t0 <- col amount * 4
    add s2, s2, t0 # s2 <- s2 + (row amount * 4) (next vector in matrix)
    addi s3, s3, -1
    
    j score_loop
    
    score_end:     
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    
    ret

# (out) a0: address of the selected vector (int*)
# (in)  a1: address of matrix (int*)
# (in)  a2: #rows (int)
# (in)  a3: #cols (int)
# (in)  a4: target row
select_vector_in_matrix:
    # TODO

# (out) a0: index of the predicted token in the vocabulary (int)
# (in)  a0: address of target vector (int*)
# (in)  a1: vocabulary embeddings address (int*)
# (in)  a2: number of tokens in vocabulary (int)
decide_next_token:
    # TODO

#############################################################################################################
# Dot product and argmax helper functions.
#############################################################################################################

# (in)  a1: address of first vector (int*)
# (in)  a2: address of second vector (int*)
# (in)  a3: length of the vectors (int)
# (out) a0: status code (0 for success, non-zero for error)
# (out) a1: dot product result (int)
dot:
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the result and the loop index.
    mv t0, zero                                     # t0 will hold the result (dot product)
    mv t1, zero                                     # t1 will be our loop index
    # Let's see first if SIZE < 1, and jump to dot_end if that's the case.
    slti t2, a3, 1                                  # t2 = (SIZE < 1)
    beq t2, zero, dot_loop                          # If SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # Set a0 to 50 to indicate an error (invalid size)
    j dot_end                                       # If SIZE < 1, jump to dot_end
dot_loop:
    beq t1, a3, dot_end_loop                        # If t1 == SIZE, we are done
    lw t2, 0(a1)                                    # Load A[t1] into t2
    lw t3, 0(a2)                                    # Load B[t1] into t3
    mul t4, t2, t3                                  # t4 = A[t1] * B[t1]
    # Check if the multiplication of A[t1] and B[t1] overflows
    mulh t5, t2, t3                                 # t5 = high 32 bits of A[t1] * B[t1] (signed)
    srai t6, t4, 31                                 # t6 = sign extension of low 32 bits (0 or -1)
    bne t5, t6, overflow                            # Overflow if high bits != sign extension of low bits
    mv t6, t0                                       # Store the current result in t6 for overflow checking
    add t0, t0, t4                                  # t0 += A[t1] * B[t1]
    # Check if the previous addition caused an overflow
    # Careful: adding negative numbers will correctly result in a negative number, so we need to check for overflow in both directions.
    bgt t6, zero, check_positive_overflow           # If previous result was positive, check for positive overflow
    blt t6, zero, check_negative_overflow           # If previous result was negative, check for negative overflow
    j dot_continue_loop
check_positive_overflow:
    blt t4, zero, dot_continue_loop                 # If we added a negative number, we can't have a positive overflow
    blt t0, zero, overflow                          # If t0 < 0 after adding a positive number, we have an overflow
    j dot_continue_loop
check_negative_overflow:
    bgt t4, zero, dot_continue_loop                 # If we added a positive number, we can't have a negative overflow
    bgt t0, zero, overflow                          # If t0 > 0 after adding a negative number, we have an overflow
    j dot_continue_loop
dot_continue_loop:
    addi a1, a1, 4                                  # Move to the next element in A
    addi a2, a2, 4                                  # Move to the next element in B
    addi t1, t1, 1                                  # t1++
    j dot_loop                                      # Repeat the loop
dot_end_loop:
    li a0, 0                                        # Set a0 to 0 to indicate success
    mv a1, t0                                       # Move the result into a1 for return
    j dot_end                                       # Jump to the end of the function
overflow:
    li a0, 200                                      # Set a0 to 200 to indicate an overflow error
    j dot_end                                       # Jump to the end of the function
dot_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # Return to the caller

# (in)  a1: pointer to int array
# (in)  a2: array length
# (out) a0: status code
# (out) a1: index of the largest element
argmax:
    # Get the index of the maximum value in A, which is of size SIZE.
    # The result will be stored in a0.
    # If here's a draw, return the smallest index among the maximum values.
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the max value and the index of the max value.
    lw t0, 0(a1)                                    # t0 will hold the max value
    mv t1, zero                                     # t1 will hold the index of the max value
    mv t2, zero                                     # t2 will be our loop index
    # Error checking first: if SIZE < 1, we should return 50 to indicate an error.
    slti t3, a2, 1                                  # t3 = (SIZE < 1)
    beq t3, zero, argmax_loop                       # if SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # set a0 to 50 to indicate an error (invalid size)
    j argmax_end                                    # if SIZE < 1, jump to argmax_end
argmax_loop:
    # The actual loop logic.
    beq t2, a2, argmax_end_loop                     # if t2 == SIZE, we are done
    lw t3, 0(a1)                                    # load A[t2] into t3
    ble t3, t0, argmax_next                         # if A[t2] <= max_value, skip to next
    mv t0, t3                                       # max_value = A[t2]
    mv t1, t2                                       # index_of_max = t2
argmax_next:
    addi a1, a1, 4                                  # move to the next element in A
    addi t2, t2, 1                                  # t2++
    j argmax_loop                                   # repeat the loop
argmax_end_loop:
    mv a1, t1                                       # move the index of the max value into a1 for return
    li a0, 0                                        # set a0 to 0 to indicate success
argmax_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # return to the caller

exit_with_code:
    li a7, CONST_SYSCALL_EXIT2
    ecall

#############################################################################################################
# Helper functions for printing and debugging.
#############################################################################################################

.data
PRINT_HEADER_VOCABULARY:    .string "=== Vocabulary ==="
PRINT_HEADER_INPUT:         .string "=== Input ==="
PRINT_HEADER_INPUT_INDICES: .string "=== Input Indices ==="
PRINT_HEADER_MATRIX:        .string "=== Matrix ==="
PRINT_HEADER_SCORES:        .string "=== Scores ==="
PRINT_HEADER_NEXT_TOKEN:    .string "=== Decision ==="
PRINT_VECTOR_LB:            .string "[ "
PRINT_VECTOR_RB:            .string "]"

.text
# Prints a null-terminated string followed by a newline.
# (in) a0: buffer to print (char*)
println:
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    ret

# Prints the vocabulary buffer.
# (in) a0: address of the vocabulary buffer (char*)
print_vocabulary:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_VOCABULARY
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input buffer as a string.
# (in) a0: address of the input buffer (char*)
print_input:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_INPUT
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input indices vector.
# (in) a0: address of the input indices vector (int*)
# (in) a1: size of the input indices vector (int)
print_indices:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0
    mv s1, a1
    la a0, PRINT_HEADER_INPUT_INDICES
    jal println
    mv a0, s0
    mv a1, s1
    jal print_vector
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret

print_scores:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, PRINT_HEADER_SCORES
    jal println
    la a0, SCORES_VECTOR
    lw a1, INPUT_TOTAL_TOKENS
    jal print_vector
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# a0: address of matrix to print (int*)
# a1: number of rows
# a2: number of columns
print_matrix:
    addi sp, sp, -24
    sw ra, 0(sp)                                    # return address
    sw s0, 4(sp)                                    # matrix pointer
    sw s1, 8(sp)                                    # row index
    sw s2, 12(sp)                                   # col index
    sw s3, 16(sp)                                   # number of rows
    sw s4, 20(sp)                                   # number of columns
    mv s0, a0                                       # s0 = pointer to matrix
    mv s3, a1                                       # s3 = number of rows
    mv s4, a2                                       # s4 = number of columns
    li s1, 0                                        # s1 = current row index
    la a0, PRINT_HEADER_MATRIX
    jal println
print_matrix_row_loop:
    beq s1, s3, print_matrix_done
    li s2, 0
print_matrix_col_loop:
    beq s2, s4, print_matrix_next_row
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    addi s0, s0, 4
    addi s2, s2, 1
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    j print_matrix_col_loop
print_matrix_next_row:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s1, s1, 1
    j print_matrix_row_loop
print_matrix_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    ret

# a0: address of vector to print (int*)
# a1: number of elements (int)
print_vector:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0                                       # s0 = pointer to vector
    mv s1, a1                                       # s1 = number of elements
    la a0, PRINT_VECTOR_LB                          # Print "[ "
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
print_vector_loop:
    beq s1, zero, print_vector_done
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 4
    addi s1, s1, -1
    j print_vector_loop
print_vector_done:
    la a0, PRINT_VECTOR_RB                          # Print "]"
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

# (in) a0: address of the predicted token (char*)
print_predicted_token:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_NEXT_TOKEN
    jal println
    # s0 = start of target token, print it char by char until newline or null
print_predicted_token_char:
    lb t0, 0(s0)
    beq t0, zero, print_predicted_token_nl          # null terminator
    li t1, CONST_CHAR_NEWLINE
    beq t0, t1, print_predicted_token_nl            # newline terminator
    mv a0, t0
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 1
    j print_predicted_token_char
print_predicted_token_nl:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret