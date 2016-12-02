#----------------------------Check Against Dictionary----------------------------------------#
# $s3 = FOR FILE 
# The program first checks if the middle word in the grid is used. If it is used, it checks if
# the word is found in the respective word length dictionary. If it is there it jumps to validWord,
# otherwise to invalidWord. It checks in the dictionary by counting how many letters match the input
# and if it comes across a not matching letter, the counter goes to zero. If it hits the respective
# word length of matching letters then it knows the word is correct and jumps to validWord.

againstDict:
	
	#Print that I'm checking dictionary
	li $v0, 4
	la $a0, inDictStr
	syscall
	
	#Check if the middle letter is used
	addi $t3, $0, 4			#represents middle character 
	addi $t0, $0, 0			#counter $t0 = 0
	
checkMiddleChar:
	lb $t1, displayWord($t3)
	
	loopM:
		lb $t2, inputStr($t0)			#load each character of the input string
		beq $t2, $t1, checkPreviousWords	#if the middle character is used, check against dictionary
		beq $t2, 0, invalidWord			#if it gets to the end of the string, then output invalid word because they did not use the middle character
		addi $t0, $t0, 1
		j loopM
	
checkPreviousWords:
	#Check if the word has already been used
	#Preprocessing
	addi $t0, $zero, 0		# $t0 = 0 counter
	addi $t1, $0, 0			#counter for correct letters
	addi $t2, $s2, 0		#string length
	addi $t3, $0, 0			#holds byte from array
	
	start1:
		lb $t3, inputStr($t1)			
		lb $t4, prevWords($t0)
		beq $t2, $t1, invalidWord
		beq $t3, $t4, increment1
		beq $t0, $s7, checkInputStrDict
		addi $t1, $0, 0
		addi $t0, $t0, 1
		j start1
		
	increment1:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start1
	
	
checkInputStrDict:
	
	#Preprocessing
	addi $t0, $zero, 0		# $t0 = 0 counter
	addi $t1, $0, 0			#counter for correct letters
	addi $t2, $s2, 0		#string length
	addi $t3, $0, 0			#holds byte from buffer
					
	
	#If $s2, the string length, is equal to 4, 5, 6, 7, 8, 9 - open the respective word list
	beq $s2, 4, openFour
	beq $s2, 5, openFive
	beq $s2, 6, openSix
	beq $s2, 7, openSeven
	beq $s2, 8, openEight
	beq $s2, 9, openNine
	

#------------------------------------------------------------------------------------------#

openFour:
	
	# Open File
	li	$v0, 13						# Open file
	la	$a0, fourFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readFourFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, fourBuffer					# buffer to hold input
	li	$a2, 6						# Read 66 bytes max
	syscall
	
	bltz $v0, readError
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal checkFour
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	addi $t0, $0, 0
	
	xor $a0, $a0, $a0
	lbu $a3, fourBuffer($a0)
	beq $a3, '*', invalidWord		#checks if it's at the end of the file
	
	j readFourFile	
	
#===============================================#
checkFour:
	
	start4:
		lb $t3, inputStr($t1)			#load from inputStr
		lb $t4, fourBuffer($t0)			#load from buffer
		beq $t2, $t1, validWord			#if the counter equals the string length, branch to validWord
		beq $t3, $t4, increment4		#if the characters are equal, add to correct letters count
		beq $t4, 0, return4			#if it reaches the end of the buffer, go back to get the next line of the file
		addi $t1, $0, 0				#the counter is reset to 0 since the characters did not match in a row
		addi $t0, $t0, 1			#counter added for the buffer
		j start4
		
	increment4:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start4
	return4:
		jr $ra
	
#-------------------------------------------------------------------------#

openFive:
	
	# Open File
	li	$v0, 13						# Open file
	la	$a0, fiveFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readFiveFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, fiveBuffer					# buffer to hold input
	li	$a2, 7						# Read 66 bytes max
	syscall
	
	bltz $v0, readError
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal checkFive
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	addi $t0, $0, 0
	
	xor $a0, $a0, $a0
	lbu $a3, fiveBuffer($a0)
	beq $a3, '*', invalidWord
	
	j readFiveFile	
	
#============================================#
checkFive:
	
	start5:
		lb $t3, inputStr($t1)
		lb $t4, fiveBuffer($t0)
		beq $t2, $t1, validWord
		beq $t3, $t4, increment5
		beq $t4, 0, return5
		addi $t1, $0, 0
		addi $t0, $t0, 1
		j start5
		
	increment5:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start5
	return5:
		jr $ra
	
#-------------------------------------------------------------------------#

openSix:
	
	# Open File
	li	$v0, 13						# Open file
	la	$a0, sixFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readSixFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, sixBuffer					# buffer to hold input
	li	$a2, 8						# Read 66 bytes max
	syscall
	
	bltz $v0, readError
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal checkSix
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	addi $t0, $0, 0
	
	xor $a0, $a0, $a0
	lbu $a3, sixBuffer($a0)
	beq $a3, '*', invalidWord
	
	j readSixFile	
	
#========================================#
checkSix:
	
	start6:
		lb $t3, inputStr($t1)
		lb $t4, sixBuffer($t0)
		beq $t2, $t1, validWord
		beq $t3, $t4, increment6
		beq $t4, 0, return6
		addi $t1, $0, 0
		addi $t0, $t0, 1
		j start6
		
	increment6:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start6
	return6:
		jr $ra
	

#-------------------------------------------------------------------------#

openSeven:
	
	# Open File
	li	$v0, 13						# Open file
	la	$a0, sevenFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readSevenFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, sevenBuffer					# buffer to hold input
	li	$a2, 9						# Read 66 bytes max
	syscall
	
	bltz $v0, readError
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal checkSeven
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	addi $t0, $0, 0
	
	xor $a0, $a0, $a0
	lbu $a3, sevenBuffer($a0)
	beq $a3, '*', invalidWord
	
	j readSevenFile	
	
#===================================================#
checkSeven:
	
	start7:
		lb $t3, inputStr($t1)
		lb $t4, sevenBuffer($t0)
		beq $t2, $t1, validWord
		beq $t3, $t4, increment7
		beq $t4, 0, return7
		addi $t1, $0, 0
		addi $t0, $t0, 1
		j start7
		
	increment7:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start7
	return7:
		jr $ra
	
#-------------------------------------------------------------------------#

openEight:
	
	# Open File
	li	$v0, 13						# Open file
	la	$a0, eightFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readEightFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, eightBuffer					# buffer to hold input
	li	$a2, 10						# Read 66 bytes max
	syscall
	
	bltz $v0, readError
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal checkEight
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	addi $t0, $0, 0
	
	xor $a0, $a0, $a0
	lbu $a3, eightBuffer($a0)
	beq $a3, '*', invalidWord
	
	j readEightFile	
	
#====================================================#
checkEight:
	
	start8:
		lb $t3, inputStr($t1)
		lb $t4, eightBuffer($t0)
		beq $t2, $t1, validWord
		beq $t3, $t4, increment8
		beq $t4, 0, return8
		addi $t1, $0, 0
		addi $t0, $t0, 1
		j start8
		
	increment8:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start8
	return8:
		jr $ra
#-------------------------------------------------------------------------#

openNine:
	
	# Open File
	li	$v0, 13						# Open file
	la	$a0, nineFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readNineFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, nineBuffer					# buffer to hold input
	li	$a2, 71						# Read 66 bytes max
	syscall
	
	bltz $v0, readError
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal checkNine
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	addi $t0, $0, 0
	
	xor $a0, $a0, $a0
	lbu $a3, nineBuffer($a0)
	beq $a3, '*', invalidWord
	
	j readNineFile	
	
#===============================================================#
checkNine:
	
	start9:
		lb $t3, inputStr($t1)
		lb $t4, nineBuffer($t0)
		beq $t2, $t1, validWord
		beq $t3, $t4, increment9
		beq $t4, 0, return9
		addi $t1, $0, 0
		addi $t0, $t0, 1
		j start9
		
	increment9:
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		j start9
	return9:
		jr $ra
	
#-------------------------------------------------------------------------#

	
