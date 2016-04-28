.text
.globl main

main:
	# Open (for writing) a file that does not exist
	li   $v0, 13		# system call for open file
	la   $a0, fout		# output file name
	li   $a1, 1		# Open for writing (flags are 0: read, 1: write)
	li   $a2, 0		# mode is ignored
	syscall			# open a file (file descriptor returned in $v0)
	move $s7, $v0		# save the file descriptor
	move $a1, $v0		# save the file descriptor to go into functions
	
	li $a0, 23330		# store the int to write in a0
	#jal itof		# do the first function
	
	# part 2
	li $a0, 99		#  initial Number of bears given by your friend 
	li $a1, 129		# goal The desired number of bears
	li $a2, 53		# increment Number of bears to ask your friend for
	li $a3, 4		# n The number of steps left in the game
	addi $sp, $sp, -4	# make space on stack to store 4 bytes
	sw $s7, 0($sp)		# save fd on stack
	#jal bears
	addi $sp, $sp, 4	# restore space on the stack
	
	#part 3
	la $a0, list		# input_array Integer array
	li $a1, 4		# candidate Integer being searched for in the array
	li $a2, 0		# startIndex Start index of the array
	li $a3, 7		# endIndex End index of the array
	addi $sp, $sp, -4	# make space on stack to store 4 bytes
	sw $s7, 0($sp)		# save fd on stack
	jal recursiveFindMajorityElement
	addi $sp, $sp, 4	# restore space on the stack

	
exit_program:
	li   $v0, 16		# system call for close file
	move $a0, $s7		# file descriptor to close
	syscall			# close file
	
	li $v0, 10
	syscall

.data
	list: .word 1, 2, 2, 4, 1, 4, 4, 4, -1
	fout:   .asciiz "testout.txt"      # filename for output


.include "hw4.asm"
