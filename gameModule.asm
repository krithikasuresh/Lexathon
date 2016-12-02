# Program: gameModule.asm

#-----------------------------------------------------------------------------#
# The program creates a random number that represents a line in the file and
# then the program iterates until it hits that line, and then generates another
# random number to find a nine letter word in that line to use to create the display
# 3x3 grid with a scrambled word. 

getDisplayWord:
	
	#generate the random number with the max bound at $a1
	li $a1, 6
	li $v0, 42
	syscall
		
	#add lower bound 
	add $a0, $a0, 0
	li $v0, 1 
	
	add $t1, $zero, $a0					# $t1 = holds random number for line in file
	add $t0, $zero, $zero					# $t0 = counter for the line in the file
	
getNineLetterFile:
	# Open File
	li	$v0, 13						# Open file
	la	$a0, nineFile					# $a0 = name of file to read
	move	$a1, $0						# $a1 = flags = O_RDONLY = 0
	move	$a2, $0						# $a2 = mode = 0 (reading)
	syscall
	
	move	$s3, $v0					# Store fd in $s3

readNFile: 	
	# Read from file, storing in buffer
	li	$v0, 14						# 14 = read from  file
	move	$a0, $s3					# move fd to $a0
	la	$a1, nineBuffer					# buffer to hold input
	li	$a2, 71						# 
	syscall
	
	bltz $v0, readError

	xor $a0, $a0, $a0
	lbu $a3, nineBuffer($a0)
	beq $t1, $t0, getNineWord
	beq $a3, '*', printEndFile
	
	addi $t0, $t0, 1 					#increment counter
	
	j readNFile

getNineWord:

	la $a1, displayWord
	 
	add $t1, $zero, $a0		#address of nineBuffer
	addi $t0, $zero, 0		#counter = 0
	addi $t2, $zero, 10		#loop ending variable = limit
	addi $t4, $zero, 0
	
	li $a1, 6			#generate the random number with the max bound at $a1
	li $v0, 42
	syscall
		
	add $a0, $a0, 0			#add lower bound, and print the random integer
	
	mult $t2, $a0			#Find the nine letter word by multiplying the random number by 10
	mflo $t3
	
	addi $t2, $t2, -2		#change counter limit to 8
	
	wordNLoop:
		lbu $a1, nineBuffer($t3)	#take byte from the buffer
		sb $a1, displayWord($t4)	#store byte from the buffer into displayWord
		beq $t0, $t2, scramble		#once it hits the counter, go to scramble
		addi $t3, $t3, 1		#increment address
		addi $t4, $t4, 1		#increment address
		addi $t0, $t0, 1		#add to counter
		j wordNLoop
	
scramble:

	#close file
	li	$v0, 16				
	add	$a0, $s3, $0	
	syscall	
	
	addi $t0, $zero, 0			#zero $t0 = counter
	addi $t1, $zero, 10			#$t1 = 10, limit of swapping
	la $a1, displayWord
	addi $t5, $a1, 0			#zero $t5, holds the array

	startscramble:
		beq $t0, $t1, beginDisplayGrid		#if counter equals limit, jump to print display
		#generate the random number with the max bound at $a1
		li $a1, 8				
		li $v0, 42
		syscall
		
		#add lower bound
		add $a0, $a0, 1
		li $v0, 1 
		
		add $t3, $zero, $a0 			#$t3 = random number between 1 and 8
		lb $t2, 0($t5)				#load first character to $t2
		lb $t4, displayWord($t3)		#get character from random number in displayWord
		addi $t6, $t4, 0			#temp register holds the random character
		
		sb $t2, displayWord($t3)		#store first byte into random num byte
		sb $t6, 0($t5)				#store random num byte into first byte
		
		addi $t0, $t0, 1			#increment counter
		j startscramble


#------Display Grid-------------------#
beginDisplayGrid:
	
#	la $a0, displayWord
#	li $v0, 4
#	syscall
	
	li $t5,0		#clear register for index
	li $t6,0		#clear register for array counter
	j displayGrid
		    
displayGrid:

	beq $t6, 0, formatNewline		#format new line
	beq $t6, 3, formatNewline		#format new line
	beq $t6, 6, formatNewline		#format new line
	beq $t6, 9, formatNewline		#format new line
	
returnAgain:
	beq $t6, 0, formatHorizline		#format horizontal line
	beq $t6, 3, formatHorizline		#format horizontal line
	beq $t6, 6, formatHorizline		#format horizontal line
	beq $t6, 9, formatHorizline		#format horizontal line
	
	
returnLabel:	
	lb $a1, displayWord($t5)	#getting first element
	addi $t5, $t5, 1		#move to next element
	
	li $v0, 4			#print vertical format line
	la $a0, vertLine
	syscall
	
	li $v0, 11			#printing letter
	move $a0, $a1
	syscall
	
	li $v0, 4			#print vertical format line
	la $a0, vertLine
	syscall
	
	addi $t6, $t6, 1		#counter to exit loop
	beq $t6, 10, endDisplay		# exit for now , beq too useriput later
	
	j displayGrid			#continue iterating through letter
	
formatNewline:
	
	li $v0, 4
	la $a0, emptyString
	syscall

	j returnAgain
	
formatHorizline:
	li $v0, 4
	la $a0, horizLine
	syscall
	
	li $v0, 4			#tab over
	la $a0, tabOver
	syscall
	
	j returnLabel	
	
endDisplay:
	jr $ra
	
#---------------------------------------------------------------------------------#

userInput: 
	#Prompt user input
	li $v0, 4
	la, $a0, inputPrompt
	syscall
	
	#Read user input
	li $v0, 8
	la $a0, inputBuffer
	li $a1, 15						
	syscall

	j validateStrLength 
	
#--------------------------------------------------------------#
printEndFile:
	li $v0, 4
	la $a0, endFileRead
	syscall 
	
	j exit
	
closeFile:
	li	$v0, 16						# 16 = close file
	add	$a0, $s3, $0	
	syscall	
	
	jr $ra
		
readError:
	la $a0, readErrorMsg
	li $v0, 4
	syscall
	
	j exit

	
