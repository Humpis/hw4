# Homework #4
# name: Vidar Minkovsky
# sbuid: 109756598

.text

#Part 1

#itof function
itof:
	li $t0, 0			# Number_of_digits = 0
	li $t1, 0			# negative = false
	bgez $a0, makeAsciiLoop		# if number isnt negative
	# If number is negative:
	li $t1, 1			# negative = true
	li $t2, 0xffffffff		# for subtraction. t2 can be reused
	sub $a0, $t2, $a0		# make a0 possitive 
	addi $a0, $a0, 1		# make it twos compliment
	
makeAsciiLoop:
	blez $a0, checkNegative		# while( $a0 > 0 )
	li $t2, 10			# for dividing. t2 can be reused
	div $a0, $t2			# Divide $a0 by 10
	mflo $a0			# save the quotient back into a0
	mfhi $t2			# put the remainder in t2
	addi $t2, $t2, 48		# make t2 ascii
	addi $sp, $sp, -1		# make space on stack to store 1 byte
	sb $t2, 0($sp)			# save ascii char on stack
	addi $t0, $t0, 1		# Increment the counter for number of digits
	j makeAsciiLoop

checkNegative:
	beqz $t1, preWriteStringLoop	# if negative = false
	addi $sp, $sp, -1		# make space on stack to store 1 byte
	li $t2, 45			# ascii -
	sb $t2, 0($sp)			# save '-' on stack
	addi $t0, $t0, 1		# Increment the counter for number of digits

preWriteStringLoop:
	li $t3, 0			# init counter to 0	
	move $a0, $a1      		# file descriptor 
	
writeStringLoop:
	bge  $t3, $t0, itofDone		# while counter < number of digits do:
	li   $v0, 15       		# system call for write to file
	move $a1, $sp   		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall            		# write to file
	addi $sp, $sp, 1		# pop byte off stack
	addi $t3, $t3, 1		# increment counter
	j writeStringLoop

itofDone:
	jr $ra
	
#Part 2

#bears function
bears:
	lw   $t0, ($sp)			# temporarily save fd
	
	addi $sp, $sp, -24		# make space on stack to store 4 bytes
	sw $ra, 20($sp)			# store return adress
	sw $s0, 16($sp)			# save to stack
	sw $s1, 12($sp)			# save to stack
	sw $s2, 8($sp)			# save to stack
	sw $s3, 4($sp)			# save to stack
	sw $s4, 0($sp)			# save to stack
	
	move $s0, $a0			# save initial
	move $s1, $a1			# save goal
	move $s2, $a2			# save increment
	move $s3, $a3			# save n
	move $s4, $t0			# save fd	
	
	# write(fd, "bears( ", 7);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringBears  		# address of buffer from which to write
	li   $a2, 7       		# hardcoded buffer length
	syscall            		# write to file	
	# itof(initial, fd);
	move $a0, $s0			# move initial
	move $a1, $s4			# move fd
	jal itof	
	# write(fd, ", ", 2);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringComma  		# address of buffer from which to write
	li   $a2, 2       		# hardcoded buffer length
	syscall  
	# itof(goal, fd);
	move $a0, $s1			# move goal
	move $a1, $s4			# move fd
	jal itof
	# write(fd, ", ", 2);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringComma  		# address of buffer from which to write
	li   $a2, 2       		# hardcoded buffer length
	syscall  
	# itof(increment, fd);
	move $a0, $s2			# move increment
	move $a1, $s4			# move fd
	jal itof
	# write(fd, ", ", 2);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringComma  		# address of buffer from which to write
	li   $a2, 2       		# hardcoded buffer length
	syscall 
	# itof(n, fd);
	move $a0, $s3			# move n
	move $a1, $s4			# move fd
	jal itof
	# write(fd, " )\n", 3); 
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringParaLn 		# address of buffer from which to write
	li   $a2, 3       		# hardcoded buffer length
	syscall 

checkInitialGoal:			# this is never jumped to
	bne $s1, $s2, checkN		# if (initial == goal){
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall 
	# itof(1, fd);
	li $a0, 1			# load 1
	move $a1, $s4			# move fd
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall 
	li $v0, 1			# return 1;
	j bearsDone
	
checkN:
	bnez $s3, checkRecurse1		#  else if (n == 0){
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall 
	# itof(0, fd);
	li $a0, 0			# load 0
	move $a1, $s4			# move fd
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall 
	li $v0, 0			# return 0;
	j bearsDone
	
checkRecurse1:
	
bearsDone:
	lw $ra, 20($sp)			# restore from stack
	lw $s0, 16($sp)			# restore from stack
	lw $s1, 12($sp)			# restore from stack
	lw $s2, 8($sp)			# restore from stack
	lw $s3, 4($sp)			# restore from stack
	lw $s4, 0($sp)			# restore from stack
	addi $sp, $sp, 24		# restore space on stack to store 4 bytes
	
	jr $ra


#Part 3

#recursiveFindMajorityElement function
recursiveFindMajorityElement:
	jr $ra


#iterateCandidates function
iterateCandidates:
	jr $ra


#Part 4

#recursiveFindLoneElement function
recursiveFindLoneElement:
	jr $ra




### Data Section ###
.data
stringBears: .asciiz "bears( "
stringComma: .asciiz ", "
stringParaLn: .asciiz " )\n"
stringReturn: .asciiz "return: "
stringLn: .asciiz "\n"
