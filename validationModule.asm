
validateStr: 
	la $a0, strBuffer		#pass address of user input
	la $a1, exitStr			#pass address of 'X' exit string
	la $a2, newLineStr		#pass address of newLine string
	
	add $t1, $zero, $a0		#set $t1 = strBuffer
	add $t2, $zero, $a1		#set $t2 = exitStr = 'X'
	add $t3, $zero, $a2		#set $t3 = newLineStr = \n
	
	validLengthOfStr:
		#check if there is only newLine char
		lb $t4, 0($t1)		#load byte from strBuffer = input string
		lb $t5, 0($t3)		#load byte from newLineStr = \n
		beq $t4, $t5, exit
		#check if the 2 char is the exit string
		lb $t4, 1($t1)	
		beq $t4, $t5, compExitStr
		#check if there are only 2 char and 3rd is newLine
		lb $t4, 2($t1) 
		beq $t4, $t5, exit
		#check if there are only 3 char and 4th is newLine
		lb $t4, 3($t1)
		beq $t4, $t5, exit
		#if there are at least 4 characters, the string is valid
		j convertStrToUpper
	
	compExitStr:
		lb $t4, 0($t1)  #strBuffer first char
		lb $t5, 0($t2)	#exitStr = 'X'
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
		
