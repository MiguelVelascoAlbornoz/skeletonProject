# You can change these values to test your solution.
.data
A:    .word -60000, 10000, 3000
B:    .word -20000, 40000, 70000
SIZE: .word 3

.text
main:
  la a1, A          # a1 = pointer to array A
  la a2, B          # a2 = pointer to array B
  lw a3, SIZE       # a3 = number of elements in each array
  jal ra, dot       # call dot function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program


# ==========================================================================
# FUNCTION: dot
#   This function computes the dot product of two integer arrays.
# Arguments:
#   a1 = pointer to first array
#   a2 = pointer to second array
#   a3 = array length
# Returns:
#   a0 = status code
#   a1 = dot product result
# ===========================================================================
dot:
    #Size validation
    addi  t0, x0, 1
    blt a3, t0, dot_invalid_size
    
    #Init
    addi t0, x0, 4 #t0 -> 4 bytes
    mul t1, a3, t0 #t1 -> array length in bytes
    add t2, t1, a1 #t2 -> array 1 end
    add t3, x0, x0 #t3 -> sum
    #Only t3,t2 in use
    
    #If a1 adress is lower than t2:
    #    - Read a1 and a2
    #    - add 4 to a1 and a2
    #    - Make multiplication
    #    - Sum the multiplication
    loop:
        bgeu a1, t2, dot_end #Exit loop
        
        lw t0, 0(a1)
        lw t1, 0(a2)
        #t0,t1,t2,t3 in use

        mulh t5, t0, t1 
        mul t4, t0, t1 #4 -> same index elements product
        #if t4 >= 0 t5 must be 0
        #if t4 < 0 t5 must be 0xFFFFFFFF
        srai t6, t4, 31
        bne t5, t6, dot_overflow
        #t4,t2,t3 in use
        
        add t0, t3, t4 #t0 -> sum
        
        xor t1, t3, t4 #t1 -> if t3 and t4 have different signs -> t1 < 0
        bltz t1, dot_no_overflow #t1 < 0 -> different signs -> no overflow
        
        xor t1, t3, t0 #t1 -> if t3 and t0 have different signs -> t5 < 0
        bltz t1, dot_overflow #t5 < 0 -> t3 and t0 different sign -> overflow
        
        dot_no_overflow:
            add t3, x0, t0
            addi a1, a1, 4
            addi a2, a2, 4
        j loop
dot_overflow:
    addi a0, x0, 200
    jr ra
dot_invalid_size:
    addi a0, x0, 50
    jr ra
dot_end:
  add a0, x0, x0
  add a1, x0, t3
  jr ra               # return to the caller
