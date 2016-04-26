.text
.globl main

main:

exit_program:
li $v0, 10
syscall

.data

.include "hw4.asm"
