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
			beq $s2, 1, compExitStr		#branch to check if the one character is the exit string = 'X'
			slti $t5, $s2, 4
			beq $t5, 1, exit
			
			li $t4, 9
			slt $t5, $t4, $s2
			beq $t5, 1, exit
			j convertStrToUpper
	
	compExitStr:
		lb $t4, 0($t1)  	#strBuffer first char
		lb $t5, 0($t2)		#exitStr = 'X'
		beq $t4, $t5, exit	#if they are equal, exit program = Give Up Button
	
convertStrToUpper: 
	li $t0, 0 	#$t0 = 0, counter
	
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

#----------------------------------------------------------------------------------#

getNineWord:
	#401442 characters total in the file minus 9 characters
	#Print what is read in the file
	li $v0, 4
	la $a0, nineBuffer
	syscall
	
	la $a1, displayWord
	 
	add $t1, $zero, $a0		#address of nineBuffer
	addi $t0, $zero, 0		#counter = 0
	addi $t2, $zero, 10		#loop ending variable = limit
	addi $t4, $zero, 0
	
	li $a1, 6			#generate the random number with the max bound at $a1
	li $v0, 42
	syscall
		
	add $a0, $a0, 0			#add lower bound, and print the random integer
	li $v0, 1 
	syscall
	
	mult $t2, $a0			#Find the nine letter word by multiplying the random number by 10
	mflo $t3
	
	addi $t2, $t2, -2		#change counter limit to 8
	
	wordNLoop:
		lbu $a1, nineBuffer($t3)	#take byte from the buffer
		sb $a1, displayWord($t4)	#store byte from the buffer into displayWord
		beq $t0, $t2, printWord		#once it hits the counter, go to print word
		addi $t3, $t3, 1		#increment address
		addi $t4, $t4, 1		#increment address
		addi $t0, $t0, 1		#add to counter
		j wordNLoop
		
printWord:
	li $v0, 4
	la $a0, displayWord
	syscall
	
	j closeFile
		
		
#---------------------------------------------------------------------------------#