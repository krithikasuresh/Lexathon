# Program: gameModule.asm

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
	
userInput: 
	#Read user input
	li $v0, 8
	la $a0, strBuffer
	li $a1, 11						# max 9 characters
	syscall

	j validateStr 

printInput:
	#Print result string
	li $v0, 4
	la $a0, strBuffer
	syscall
	jr 	$ra
	
readFile:
	# Open File
	li	$v0, 13						# Open file
	la	$a0, file					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	move	$s2, $v0					# Store fd in $s2	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s2					# move fd to $a0
	la	$a1, buffer					# buffer to hold input
	li	$a2, 1024					# Read 1024 bytes max
	syscall
	# Close file
	li	$v0, 16						# 16 = close file
	add	$a0, $s2, $0	
	syscall	
	
	# Search file for string
in:	li	$v0, 4
	la 	$a0, strMsg
	syscall
	li	$v0, 8
	la	$a0, inputStr
	li	$a1, 10
	syscall
	jal	checkTime
	j	in

timeOut:
	li	$v0, 4
	la	$a0, timeOutMsg
	syscall
	j	exit
	
