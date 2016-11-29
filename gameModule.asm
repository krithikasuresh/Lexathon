# Program: gameModule.asm

#---------------------------------------------------------------------#

beginCountdown:
	li	$s1, 60						# Initialize s1 to hold 60s
	li	$v0, 30						# Get time of countdown start
	syscall
	sw	$a0, startTime					# Store start time
	jr	$ra

checkTime:
	lw	$t0, startTime					# Load start time
	li	$v0, 30						# Get current time
	syscall
	sub	$s0, $a0, $t0					# Calculate difference btw current and start time
	div	$s0, $s0, 1000					# Convert time from ms to s
	sub	$s0, $s1, $s0					# Calculate remaining time
	slti	$t1, $s0, 1					# Check if remaining time is less or equal to 0
	bne	$t1, $0, timeOut				# End game when time is up
	li	$v0, 4
	la	$a0, displayTime
	syscall
	move	$a0, $s0
	li	$v0, 1
	syscall
	li	$v0, 4
	la	$a0, newLine
	syscall
	jr	$ra

#--------------------------------------------------------------------------#

userInput: 
	#Prompt user input
	li $v0, 4
	la, $a0, inputPrompt
	syscall
	
	#Read user input
	li $v0, 8
	la $a0, strBuffer
	li $a1, 15						# max 9 characters
	syscall

	j validateStrLength 

printInput:
	#Print result string
	li $v0, 4
	la $a0, strBuffer
	syscall
	
	li $v0, 1
	move $a0, $s2			#$s2 holds string length
	syscall
	jr 	$ra

#-----------------------------------------------------------------------------#
# The program creates a random number that represents a line in the file and
# then the program iterates until it hits that line, and then generates another
# random number to find a nine letter word in that line to use to create the display
# 3x3 grid with a shuffled word. 

getDisplayWord:
	
	#generate the random number with the max bound at $a1
	li $a1, 2		#CHANGE TO 5819 		
	li $v0, 42
	syscall
		
	#add lower bound, and print the random integer
	add $a0, $a0, 0
	#div $a0, $a0, 
	li $v0, 1 
	syscall	
	
	add $t1, $zero, $a0					# $t1 = holds random number for line in file
	add $t0, $zero, $zero					# $t0 = counter for the line in the file
	
getNineLetterFile:
	# Open File
	li	$v0, 13						# Open file
	la	$a0, nineFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s2, $v0					# Store fd in $s2

readNFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s2					# move fd to $a0
	la	$a1, nineBuffer					# buffer to hold input
	li	$a2, 71						# Read 401451 bytes max
	syscall
	
	bltz $v0, readError
	
#	#Print what is read in the file
#	li $v0, 4
#	la $a0, nineBuffer
#	syscall
	
	move $s3, $a0
	
	xor $a0, $a0, $a0
	lbu $a3, nineBuffer($a0)
	beq $t1, $t0, getNineWord
	beq $a3, '*', printEndFile
	
#	li $v0, 4
#	la $a0, emptyString
#	syscall
	
	addi $t0, $t0, 1 					#increment counter
	
	j readNFile
	#j getNineWord
	
#	# Print file contents
#	li	$v0, 4	
#	la	$a0, buffer		
#	syscall		

printEndFile:
	li $v0, 4
	la $a0, endFileRead
	syscall 
	
	j exit
	
closeFile:
	li	$v0, 16						# 16 = close file
	add	$a0, $s2, $0	
	syscall	
	j exit
		
#readFile:
#	# Open File
#	li	$v0, 13						# Open file
#	la	$a0, file					# $a0 = name of file to read
#	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
#	move	$a2, $0						# $a2 = mode = 0 (reading)
#	syscall
#	move	$s2, $v0					# Store fd in $s2	
#	# Read from file, storing in buffer
#	li	$v0, 14						# 14 = read from  file
#	move	$a0, $s2					# move fd to $a0
#	la	$a1, buffer					# buffer to hold input
#	li	$a2, 1024					# Read 1024 bytes max
#	syscall
	
#	# Print file contents
#	li	$v0, 4	
#	la	$a0, buffer		
#	syscall		
	
	# Close file
#	li	$v0, 16						# 16 = close file
#	add	$a0, $s2, $0	
#	syscall	
	
	# Search file for string
#in:	li	$v0, 4
#	la 	$a0, strMsg
#	syscall
#	li	$v0, 8
#	la	$a0, inputStr
#	li	$a1, 10
#	syscall
#	jal	checkTime
#	j	in

readError:
	la $a0, readErrorMsg
	li $v0, 4
	syscall
	j exit

timeOut:
	li	$v0, 4
	la	$a0, timeOutMsg
	syscall
	j	exit
	
