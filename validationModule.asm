# Program: validationModule.asm
#---------------------------------------------------------------------------#
validateStrLength: 
	la $a0, strBuffer		#pass address of user input
	la $a1, exitStr			#pass address of 'X' exit string
	la $a2, newLineStr		#pass address of newLine string
	
	add $s2, $zero, $zero		#set $s2 = strlength = 0 		
	add $t1, $zero, $a0		#set $t1 = strBuffer
	lb $t2, 0($a1)			#set $t2 = exitStr = 'X'
	lb $t3, 0($a2)			#set $t3 = newLineStr = \n
	
	getLengthOfStr:
		
		loopStr: 
			lb $t4, 0($t1)
			beq $t4, $t3, isValidLength
			addi $t1, $t1, 1
			addi $s2, $s2, 1
			j loopStr
		
		isValidLength:
			#check if string length is less than 4 characters
			beq $s2, 1, checkExitorShuffle		#branch to check if the one character is the exit string = 'X'
			slti $t5, $s2, 4
			beq $t5, 1, exit
			
			li $t4, 9
			slt $t5, $t4, $s2
			beq $t5, 1, exit
			j convertStrToUpper
	
checkExitorShuffle:
	checkExit:
		lb $t4, 0($t1)  			#strBuffer first char
		lb $t5, 0($t2)				#exitStr = 'X'
		beq $t4, $t5, exit			#if they are equal, exit program = Give Up Button
	
	checkShuffle:
		la $a1, shuffleStr			#pass address of shuffle string
		lb $t2, 0($a1)				#set $t2 = shuffleStr = 'S'
		#lb $t4, 0($t1)  			#strBuffer first char
		lb $t5, 0($t2)				#shuffleStr = 'S'
		beq $t4, $t5, shuffle			#if they are equal, shuffle
	
	shuffle:
		li $v0, 4
		la $a0, shuffling
		syscall 
		
		j exit
	
convertStrToUpper: 
	li $t0, 0 					#$t0 = 0, counter
	
	convBegin:
		slti $t1, $t0, 11 		#$t1 = 1 if $t0 < 10
		beq $t1, $0, validEnd		#loop controller
		lb $t4, 0($a0)			#load character of string
		beqz $t4, validEnd		#if there are no more characters, end conversion
		beq $t4, 10, validEnd
		slti $t2, $t4, 91
		li $t3, 1			# set $t3 to 1 to rep true
		bne $t2, $t3, toUpper		#if it is not true, convert to upper
		
	toUpper:
		addi $t4, $t4, -32 		#subtracts 32 from char value to capitalize
	
	convDone:
		addi $t0, $t0, 1		#increment
		sb $t4, 0($a0)			#store back changed character
		addi $a0, $a0, 1
		j convBegin
	
validEnd:
	j printInput
	

#--------------------------------------------------------------------------------------------#

	


#----------------------------Valid Against Dictionary----------------------------------------#



