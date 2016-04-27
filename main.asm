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
	
	li $a0, -123		# store the int to write in a0
	jal itof		# do the first function
	
	li   $v0, 16		# system call for close file
	move $a0, $s7		# file descriptor to close
	syscall			# close file
	
exit_program:
	li $v0, 10
	syscall

.data
	fout:   .asciiz "testout.txt"      # filename for output

.include "hw4.asm"
