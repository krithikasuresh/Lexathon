# Program: validationModule.asm

# $s2 = STRING LENGTH
# validateStrLength checks whether the user input is valid, and if it is
# converts it to all uppercase for checking against the dictionary. It
# also checks that if the user inputs one character, then it will check 
# whether it is the 'X' - exit or 'S' - shuffle, and do those respective
# actions. 

#---------------------------------------------------------------------------#
validateStrLength: 
	la $a0, inputBuffer		#pass address of user input
	la $a1, exitStr			#pass address of 'X' exit string
	la $a2, newLineStr		#pass address of newLine string
	
	add $s2, $zero, $zero		#set $s2 = strlength = 0 		
	add $t1, $zero, $a0		#set $t1 = strBuffer
	lb $t2, 0($a1)			#set $t2 = exitStr = 'X'
	lb $t3, 0($a2)			#set $t3 = newLineStr = \n
	
	getLengthOfStr:
		
		loopStr: 
			lb $t4, 0($t1)				# Loop that gets the length of the input string
			beq $t4, $t3, isValidLength
			addi $t1, $t1, 1
			addi $s2, $s2, 1
			j loopStr
		
		isValidLength:
			#check if string length is less than 4 characters
			beq $s2, 1, checkExitorShuffle		#branch to check if the one character is X, S, T
			slti $t5, $s2, 4			#checks if length is less than 4
			beq $t5, 1, invalidWord
			
			li $t4, 9				#checks if the length is greater than 9
			slt $t5, $t4, $s2
			beq $t5, 1, invalidWord
			j convertStrToUpper
	
checkExitorShuffle:
	checkExit:
		la $t2, exitStr
		la $t1, inputBuffer
		lb $t4, 0($t1)  			#inputBuffer first char
		lb $t5, 0($t2)				#exitStr = 'X'
		beq $t4, $t5, exit			#if they are equal, exit program = Give Up Button
	
	checkShuffle:
		la $t2, shuffleStr			#pass address of shuffle string
		la $t1, inputBuffer
		lb $t4, 0($t1)
		lb $t5, 0($t2)				#set $t2 = shuffleStr = 'S'
		beq $t4, $t5, shuffle			#if they are equal, shuffle
		j invalidWord
	
	shuffle:
		#preprocessing
		addi $t0, $zero, 0			#zero $t0 = counter
		addi $t1, $zero, 10			#$t1 = 10, limit of swapping
		la $a1, displayWord
		addi $t5, $a1, 0			#zero $t5, holds the array
		
	startShuffle:
		beq $t0, $t1, endShuffle	#if counter equals limit, jump to print display
		#generate the random number with the max bound at $a1
		li $a1, 8				
		li $v0, 42
		syscall
		
		#add lower bound
		add $a0, $a0, 1
		li $v0, 1 
		
		add $t3, $zero, $a0 			#$t3 = random number between 1 and 8
		beq $t3, 4, startShuffle		#Keep the middle (4) character in the middle by not shuffling it
		lb $t2, 0($t5)				#load first character to $t2
		lb $t4, displayWord($t3)		#get character from random number in displayWord
		addi $t6, $t4, 0			#temp register holds the random character
		
		sb $t2, displayWord($t3)		#store first byte into random num byte
		sb $t6, 0($t5)				#store random num byte into first byte
		
		addi $t0, $t0, 1			#increment counter
		j startShuffle

	endShuffle:		
		addi $sp, $sp, -4	#make room on the stack
		sw $ra, 0($sp)		#store return address	
		jal beginDisplayGrid
		lw $ra, 0($sp)		#restore return address
		addi $sp, $sp, 4
		j userInput
	
convertStrToUpper: 
	li $t0, 0 				#$t0 = 0, counter
	li $t3, 1				# set $t3 to 1 to rep true
	
	convBegin:
		slti $t1, $t0, 11 		#$t1 = 1 if $t0 < 10
		beq $t1, $0, validEnd		#loop controller
		lb $t4, 0($a0)			#load character of string
		beqz $t4, validEnd		#if there are no more characters, end conversion
		slti $t2, $t4, 96
		bne $t2, $t3, toUpper		#if it is not true, convert to upper
		j convDone			#if it is already uppercase
		
	toUpper:
		addi $t4, $t4, -32 		#subtracts 32 from char value to capitalize
	
	convDone:
		addi $t0, $t0, 1		#increment
		sb $t4, 0($a0)			#store back changed character
		addi $a0, $a0, 1
		j convBegin
	
validEnd:
	addi $t0, $zero, 0
	add $t1, $zero, $s2
	
	la $t4, inputStr
	la $t3, inputBuffer
	
storeInputStr:
	beq $t0, $t1, againstDict
	lb $t4, inputBuffer($t0)
	sb $t4, inputStr($t0)
	beq $t4, 0, againstDict
	
	addi $t0, $t0, 1
	
	j storeInputStr

#-----------------------------------------------------------#

invalidWord:	
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal closeFile
	
	# Print wrong word
	li $v0, 4
	la $a0, notAWord
	syscall
	
	jal beginDisplayGrid
	jal checkTime
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	j userInput
	
validWord:
	
	addi $sp, $sp, -4	#make room on the stack
	sw $ra, 0($sp)		#store return address
	jal closeFile
	
	#Store the correct word in array, so that it can not be used again
	# $s7 counter of array end of stored words for prevWords
	addi $t2, $s2, 0		#string length
	addi $t3, $0, 0			#holds byte from input string
	addi $t1, $0, 0			#counter
	
	startStoreWord:
		lb $t3, inputStr($t1)		#load character from input string	
		sb $t3, prevWords($s7)		#store it into prevWords array
		beq $t1, $t2, printValid	#once the entire string is stored go to show valid word screen
		addi $s7, $s7, 1		#increment in prevWords
		addi $t1, $t1, 1		#increment in string
		j startStoreWord
		

printValid:
	#Print
	li $v0, 4
	la $a0, isAWord
	syscall
	
	jal addPoints
	jal addTime
	jal checkTime
	
	lw $ra, 0($sp)		#restore return address
	addi $sp, $sp, 4
	
	j userInput
	
