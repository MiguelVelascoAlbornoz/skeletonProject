# You can change these values to test your solution.
.data
ARRAY: .word -6 -1 6 1
SIZE:  .word 4
INDEX: .word 2

.text
main:
  la a1, ARRAY      # a1 = pointer to array
  lw a2, SIZE       # a2 = array length
  lw a3, INDEX      # a3 = element index
  jal ra, select    # call select function
exit:
  li a7, 10         # exit syscall code
  ecall             # terminate the program

# ==========================================================================
# FUNCTION: select
#   This function selects an element from an integer array.
# Arguments:
#   a1 = pointer to int array
#   a2 = array length
#   a3 = element index
# Returns:
#   a0 = status code
#   a1 = value of the selected element
# ===========================================================================
select:
    li t0, 1 #t0 = 1    
    blt a2, t0, inv_args #a2 < t0 -> Sit1 (tamanho menor a 1)
    blt a3, x0, index_out_of_bounds #elementIndex  < 0 (index out of bounds) 
    bge a3, a2, index_out_of_bounds #elementIndex >= arrayLength (index out of bounds)
    slli t1, a3, 2 #t1 = elementIndex*(2^2)
    li a0, 0 #a0 = 0 
    add t1, a1, t1 #t1 = arrayPointer+elementIndex*4
    lw a1, 0(t1) #a1 = element[t1]
    j select_end 
    inv_args: 
        li a0, 50
        j select_end
    index_out_of_bounds: li a0, 100
        j select_end
    select_end:
        jr ra   # return to the caller
