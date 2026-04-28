  # You can change these values to test your solution.
.data
ARRAY: .word -6 -1 -6 -2
SIZE:  .word 4

.text
main:
  la a1, ARRAY        # a1 = pointer to array
  lw a2, SIZE         # a2 = number of elements in the array
  jal ra, argmax      # call argmax function
exit:
  li a7, 10           # exit syscall code
  ecall               # terminate the program

# ==========================================================================
# FUNCTION: argmax
#   Takes an array of integers and returns the index of the largest element.
#   If there are multiple elements with the same maximum value, 
#   it should return the smallest index among them.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
# Returns:
#   a0 = status code
#   a1 = index of the largest element
# ===========================================================================

argmax:
    # move exit code 50 to registry and return if array length < 1
    bgt a2, x0, valid
    li a0, 50
    j argmax_end
    
    valid:
    
    lw t0, 0(a1)    # t0 <- max value
    li t1, 0    # t1 <- max index
    li t2, 1    # t2 <- current index
    addi a1, a1, 4
    bge t2, a2, end
    
    loop:       # loop to check every integer in array
        lw t3, 0(a1) # t3 <- current value
        ble t3, t0, not_bigger # check if current value is bigger than max
        
        mv t0, t3    # update new maxes
        mv t1, t2
            
        not_bigger:
            addi a1, a1, 4    # increase current index and pointer
            addi t2, t2, 1
            
        blt t2, a2, loop    # repeat loop if not reached end of array
        
    end:
        li a0, 0    # move status code and max index into right registries
        mv a1, t1
          

argmax_end:
  jr ra               # return to the caller
