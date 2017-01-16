#############################################
# Basic calculator for addition, subtraction
#############################################

				.data
menuPrompt:	.asciiz "Enter a number from the\nfollowing list of options.\n"
menuList:	.asciiz "   1. Add integers\n   2. Subtract integers\n   5. Exit\n"
line:		.asciiz "\n----------------------\n"
badInputMsg:	.asciiz "\nInvalid input entered. Value must be an integer from 1 to 5!"
exitMsg:	.asciiz "\nGoodbye!"
intPrompt:	.asciiz	"Enter an integer: "
resultLabel:	.asciiz "Result: "

###############################
# $t0 = User's menu selection
# $t1 = First integer
# $t2 = Second integer
###############################
				.text
				.globl main
main:		
		# Print menu prompt
		li $v0, 4
		la $a0, line
		syscall
		la $a0, menuPrompt
		syscall
		# Print menu option list
		la $a0, menuList
		syscall
		# Read in user's menu selection
		li $v0, 5
		syscall
		add $t0, $v0, $0
		
		# If addition was selected, jump
		li $v0, 1
		beq $t0, $v0, addFunc
		# If subtraction was selected, jump
		li $v0, 2
		beq $t0, $v0, subFunc
		# If exit was not selected, display invalid user input message
		li $v0, 5
		bne $t0, $v0, badInput
		
		# Print exit message
		li $v0, 4
		la $a0, exitMsg
		syscall
		# Terminate program
		li $v0, 10
		syscall

badInput:
		# Print bad input message
		li $v0, 4
		la $a0, badInputMsg
		syscall
		
		# Return to main function
		j main

# Reads in two integers from user input
intRead:
		# Prompt user for integer
		li $v0, 4
		la $a0, intPrompt
		syscall
		
		# Read in first integer
		li $v0, 5
		syscall
		move $t1, $v0
		
		# Prompt user for integer
		li $v0, 4
		la $a0, intPrompt
		syscall
		
		# Read in second integer
		li $v0, 5
		syscall
		move $t2, $v0
		
		# Return to calling function
		jr $ra

# Prints calculation result
printResult:
		# Print result label
		li $v0, 4
		la $a0, resultLabel
		syscall

		# Print result
		li $v0, 1
		add $a0, $t9, $0
		syscall
		
		# Return to calling function
		jr $ra

# Adds two integers, prints result
addFunc:
		# Jump to integer reading function
		jal intRead
		
		# Calculate sum of integers entered
		add $t9, $t1, $t2
		
		# Print sum calculated
		jal printResult
		
		# Return to main function
		j main
	
# Subtracts one integer from another, prints result	
subFunc:
		jal intRead
		
		# Calculate difference of integers entered
		sub $t9, $t1, $t2
		
		# Print difference calculated
		jal printResult
		
		# Return to main function
		j main