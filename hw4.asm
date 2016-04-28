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
	li $t2, 10			# for dividing. t2 can be reused
	div $a0, $t2			# Divide $a0 by 10
	mflo $a0			# save the quotient back into a0
	mfhi $t2			# put the remainder in t2
	addi $t2, $t2, 48		# make t2 ascii
	addi $sp, $sp, -1		# make space on stack to store 1 byte
	sb $t2, 0($sp)			# save ascii char on stack
	addi $t0, $t0, 1		# Increment the counter for number of digits
	blez $a0, checkNegative		# while( $a0 > 0 )
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
	bne $s0, $s1, checkN		# if (initial == goal){
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall 
	# itof(1, fd);
	li $a0, 1			# load 1
	move $a1, $s4			# move fd
	jal itof
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
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall 
	li $v0, 0			# return 0;
	j bearsDone
	
checkRecurse1:
	add $a0, $s0, $s2		# initial+increment
	move $a1, $s1			# goal
	move $a2, $s2			# increment
	addi $a3, $s3, -1		# n - 1
	addi $sp, $sp, -4		# make space on stack to store 4 bytes
	sw $s4, 0($sp)			# save fd on stack
	jal bears
	addi $sp, $sp, 4		# restore space on the stack
	bne $v0, 1, checkRecurse2	# else if (bears(initial+increment, goal, increment, n-1) == 1){
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall
	# itof(1, fd);
	li $a0, 1			# load 1
	move $a1, $s4			# move fd
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall 
	li $v0, 1			# return 1;
	j bearsDone

checkRecurse2:
	li $t0, 2			# for mod
	div $s0, $t0			# initial mod 2
	mfhi $t0			# move remainder to t0
	bnez $t0, bearsElse		# else if ((initial % 2 == 0) {
	sra $a0, $s0, 1			# initial/2
	move $a1, $s1			# goal
	move $a2, $s2			# increment
	addi $a3, $s3, -1		# n - 1
	addi $sp, $sp, -4		# make space on stack to store 4 bytes
	sw $s4, 0($sp)			# save fd on stack
	jal bears
	addi $sp, $sp, 4		# restore space on the stack
	bne $v0, 1, bearsElse		# else if (bears(initial/2, goal, increment, n-1) == 1)){
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall
	# itof(1, fd);
	li $a0, 1			# load 1
	move $a1, $s4			# move fd
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall
	li $v0, 1			# return 1;
	j bearsDone
	
bearsElse:
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall
	# itof(0, fd);
	li $a0, 0			# load 0
	move $a1, $s4			# move fd
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall
	li $v0, 0			# return 1;
	j bearsDone
	
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
	lw   $t0, ($sp)			# temporarily save fd
	
	addi $sp, $sp, -36		# make space on stack to store 4 bytes
	sw $s7, 32($sp)			# save to stack 
	sw $s6, 28($sp)			# save to stack 
	sw $s5, 24($sp)			# save to stack 
	sw $ra, 20($sp)			# store return adress
	sw $s0, 16($sp)			# save to stack
	sw $s1, 12($sp)			# save to stack
	sw $s2, 8($sp)			# save to stack
	sw $s3, 4($sp)			# save to stack
	sw $s4, 0($sp)			# save to stack

	move $s0, $a0			# save input array
	move $s1, $a1			# save candidate int
	move $s2, $a2			# save start index
	move $s3, $a3			# save end index
	move $s4, $t0			# save fd	
	
	sub $s5, $s3, $s2		# array_length = (endIndex - startIndex)
	addi $s5, $s5, 1		# array_length + 1
	
	# write(fd, "recursiveFindMajorityElement( ", 30);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringRFME 		# address of buffer from which to write
	li   $a2, 30       		# hardcoded buffer length
	syscall
	# itof(startIndex, fd);
	move $a0, $s2			# move startIndex
	move $a1, $s4			# move fd
	jal itof
	# write(fd, ", ", 2);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringComma  		# address of buffer from which to write
	li   $a2, 2       		# hardcoded buffer length
	syscall 
	# itof(endIndex, fd);
	move $a0, $s3			# move endIndex
	move $a1, $s4			# move fd
	jal itof
	# write(fd, ", ", 2);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringComma  		# address of buffer from which to write
	li   $a2, 2       		# hardcoded buffer length
	syscall 
	# itof(array_length, fd);
	move $a0, $s5			# move arrayLength
	move $a1, $s4			# move fd
	jal itof
	# write(fd, " )\n", 3); 
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringParaLn 		# address of buffer from which to write
	li   $a2, 3       		# hardcoded buffer length
	syscall 
	
	li $t0, 1			# for checking if equal to 1
	bne $s5, $t0, rfmeOuterElse	# if(array_length == 1){
	add $t0, $s0, $s2		# t0 = pointer for array[startIndex]
	lw $t0, ($t0)			# t0 = array[startIndex]
	bne $s1, $t0, rfmeInnerElse	# if(candidate == array[startIndex]){
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall
	# itof(1, fd);
	li $a0, 1			# load 1
	move $a1, $s4			# move fd
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall
	# return 1; 
	li $v0, 1			# return 1
	j rfmeDone
	
rfmeInnerElse:
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall
	# itof(0, fd);
	li $a0, 0			# load 0
	move $a1, $s4			# move fd
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall
	# return 0; 
	li $v0, 0			# return 0
	j rfmeDone

rfmeOuterElse:
	sra $t0, $s5, 1			# mid = arraylength/2
	addi $sp, $sp, -4		# make space on stack to store 4 bytes
	sw $t0, 0($sp)			# save fd on stack
	
	li $s6, 0			# LHS_sum = 0
	li $s7, 0			# RHS_sum = 0
	
	# LHS_sum = recursiveFindMajorityElement(array, candidate, startIndex, (startIndex + mid -1));
	move $a0, $s0			# move array
	move $a1, $s1			# move candidate
	move $a2, $s2			# move startIndex
	add $a3, $s2, $t0		# move endindex = start + mid
	addi $a3, $a3, -1		# move endindex--
	addi $sp, $sp, -4		# make space on stack to store 4 bytes
	sw $s4, 0($sp)			# save fd on stack
	jal recursiveFindMajorityElement
	addi $sp, $sp, 4		# restore space on the stack
	move $s6, $v0			# LHS_sum = recursiveFindMajorityElement(array, candidate, startIndex, (startIndex + mid -1));

	# get mid back
	lw $t0, 0($sp)			# load t0 from stack 
	addi $sp, $sp, 4		# restore space on the stack
	
	# RHS_sum = recursiveFindMajorityElement(array, candidate, (startIndex + mid), endIndex);
	move $a0, $s0			# move array
	move $a1, $s1			# move candidate
	add $a2, $s2, $t0		# move startindex = start + mid
	move $a3, $s3			# move endindex
	sw $s4, 0($sp)			# save fd on stack
	jal recursiveFindMajorityElement
	addi $sp, $sp, 4		# restore space on the stack
	move $s7, $v0			#  RHS_sum = recursiveFindMajorityElement(array, candidate, (startIndex + mid), endIndex);
	
	# write(fd, "return: ", 8);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringReturn 		# address of buffer from which to write
	li   $a2, 8       		# hardcoded buffer length
	syscall
	# itof((LHS_sum + RHS_sum), fd);
	add $a0, $s6, $s7		# move LHS_sum + RHS_sum
	move $a1, $s4			# move fd
	jal itof
	# write(fd, "\n", 1);
	li   $v0, 15       		# system call for write to file
	move $a0, $s4      		# file descriptor 
	la   $a1, stringLn 		# address of buffer from which to write
	li   $a2, 1       		# hardcoded buffer length
	syscall
	# return (LHS_sum + RHS_sum);
	add $v0, $s6, $s7		# return LHS_sum + RHS_sum
	j rfmeDone

rfmeDone:
	lw $s7, 32($sp)			# restore from stack 
	lw $s6, 28($sp)			# restore from stack
	lw $s5, 24($sp)			# restore from stack
	lw $ra, 20($sp)			# restore from stack
	lw $s0, 16($sp)			# restore from stack
	lw $s1, 12($sp)			# restore from stack
	lw $s2, 8($sp)			# restore from stack
	lw $s3, 4($sp)			# restore from stack
	lw $s4, 0($sp)			# restore from stack
	addi $sp, $sp, 36		# restore space on stack to store 4 bytes
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
stringRFME: .asciiz "recursiveFindMajorityElement( "
