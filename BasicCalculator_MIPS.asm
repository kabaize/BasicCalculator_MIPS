#############################################
# Basic calculator for integer arithmetic
#############################################

		.data
menuPrompt:	.asciiz "Enter a number from the\nfollowing list of options.\n"
menuList:	.asciiz "   1. Add integer\n   2. Subtract integer\n   3. Multiply by integer\n   4. Divide by integer\n   5. Exit\n"
line:		.asciiz "\n----------------------\n"
badInputMsg:	.asciiz "\nInvalid input entered. Value must be an integer from 1 to 5!"
exitMsg:	.asciiz "Goodbye!"
intPrompt:	.asciiz	"Enter an integer: "
resultLabel:	.asciiz "Result: "

######## Register Usage ########
# $t0 = User's menu selection
# $t1 = Integer (user input)
# $t9 = Current result
################################
		.text
		.globl main
		
###### Main function ######
main:		
		# Set current result to 0
		li $t9, 0
startMenu:
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

		# If user selected to exit program, then exit
		li $v0, 5
		beq $t0, $v0, exit
		# If no valid menu option was selected, display invalid user input message
		li $v0, 5
		bgt $t0, $v0, badInput

		# Read in integer to be used in mathematic operation
		jal intRead
		# If addition was selected, add
		li $v0, 1
		beq $t0, $v0, addFunc
		# If subtraction was selected, subtract
		li $v0, 2
		beq $t0, $v0, subFunc
		# If multiplication was selected, multiply
		li $v0, 3
		beq $t0, $v0, mulFunc
		# If division was selected, divide
		li $v0, 4
		beq $t0, $v0, divFunc
exit:
		# Print exit message
		li $v0, 4
		la $a0, exitMsg
		syscall
		# Terminate program
		li $v0, 10
		syscall

###### FUNCTIONS ######
# Prints message that user entered invalid input for menu option selection
badInput:
		# Print bad input message
		li $v0, 4
		la $a0, badInputMsg
		syscall
		
		# Return to menu
		j startMenu

# Reads in two integers from user input
intRead:
		# Prompt user for integer
		li $v0, 4
		la $a0, intPrompt
		syscall
		
		# Read in integer
		li $v0, 5
		syscall
		move $t1, $v0
		
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

# Add integer to current result, prints new result
addFunc:
		# Calculate sum
		add $t9, $t9, $t1
		
		# Print sum calculated
		jal printResult
		
		# Return to main function
		j startMenu
	
# Subtracts integer from current result, prints new result
subFunc:
		# Calculate difference
		sub $t9, $t9, $t1
		
		# Print difference calculated
		jal printResult
		
		# Return to main function
		j startMenu

# Multiplies integer with current result, prints new result
mulFunc:
		# Calculate product
		mult $t9, $t1
		mflo $t9
		
		# Print difference calculated
		jal printResult
		
		# Return to main function
		j startMenu

# Divides current result by integer, prints new result
divFunc:
		# Calculate quotient
		div $t9, $t1
		mflo $t9
		
		# Print difference calculated
		jal printResult
		
		# Return to main function
		j startMenu
