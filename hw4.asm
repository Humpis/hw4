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

