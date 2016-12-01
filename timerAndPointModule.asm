# Program: timerAndPointModule.asm
# $s0, and $s1 : timer
# $s4 = points
#-----------------------------------------------------------------------#

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
	

addTime:
	#Add 20 into register holding time left
	add $s1, $s1, 20
	jr $ra

timeOut:
	li	$v0, 4
	la	$a0, timeOutMsg
	syscall
	j	exit

#-----------------------------------------------------------------------------#

addPoints:
	#Add 2 points per character in word
	addi $t0, $0, 2
	mult $s2, $t0
	mflo $s5
	
	add $s4, $s4, $s5
	#Print total points
	li $v0, 4
	la $a0, pointTotal
	syscall
	
	#Print the number of points from register $s4
	li $v0, 1
	add $a0, $s4, $0
	syscall
	
	jr $ra
