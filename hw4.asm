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
	# Make room on the stack for one BYTE and store the byte to the
# address
	addi $t0, $t0, 1		# Increment the counter for number of digits
	j makeAsciiLoop

checkNegative:

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
	buffer: .space 32