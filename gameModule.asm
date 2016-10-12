# Program: gameModule.asm

beginCountdown:
	li	$s1, 60							# Initialize s1 to hold 60s
	li	$v0, 30							# Get time of countdown start
	syscall
	sw	$a0, startTime						# Store start time

checkTime:
	lw	$t0, startTime						# Load start time
	li	$v0, 30							# Get current time
	syscall
	sub	$s0, $a0, $t0						# Calculate difference btw current and start time
	div	$s0, $s0, 1000						# Convert time from ms to s
	sub	$s0, $s1, $s0						# Calculate remaining time
	beq	$s0, $0, timeOut
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

timeOut:
	li	$v0, 4
	la	$a0, timeOutMsg
	syscall
	j	exit