# Program: Driver.asm
# Authors: Moustapha Dieng, Janai Williams, Krithika Suresh, Hojin Shin
# Version: 1.0.0
# Description: MIPS Edition of the android game Lexathon.

# Data Segment
.data										# Variable declarations follow this line

	# Variables for Driver.asm
	borderMsg:			.asciiz "########################################################################################################\n"
	bootMsg:			.asciiz "######################################## Lexathon MIPS Edition #########################################\n"
	selectMsg:			.asciiz "PLEASE MAKE A SELECTION\n"
	newGameMsg:			.asciiz "\t1. New Game\n"
	howToPlayMsg:			.asciiz "\t2. How To Play\n"
	endGameMsg:			.asciiz "\t3. Exit\n"
	inputSelectMsg:			.asciiz "Selection: "
	gameOverMsg:			.asciiz "############################################# GAME OVER ################################################\n"
	helpMsg:			.asciiz "############################################### HELP ###################################################\n"
	gameHeader:			.asciiz "############################################ GAME RUNNING ##############################################\n"
	instructionMsg1:		.asciiz "Lexathon is a word game where you must find as many words of four or more letters in the alloted time."
	instructionMsg2:		.asciiz "\nEach word must contain the central letter exactly, while other tiles can be used no more than once."
	instructionMsg3:		.asciiz "\nYou start each game with 60 seconds and finding a new word increases that time by 20 seconds."
	instructionMsg4:		.asciiz "\nThe game ends when either:"
	instructionMsg5:		.asciiz "\n\t- Time runs out, or"
	instructionMsg6:		.asciiz "\n\t- You give up by typing X"
	instructionMsg7:		.asciiz "\n\Scores are determined of rewarding 2 points per character in the correct word."
	instructionMsg8:		.asciiz "\nSo find as many words as you can, as quickly as you can."
	instructionMsg9:		.asciiz "\nHAVE FUN!!!"
	instructionMsg10:		.asciiz "\nEnter any number to return: "
	instructionMsg11:		.asciiz "\nType X to exit or S to shuffle."
	newLine:			.asciiz	"\n"
	
	# Variables for displayGrid
	emptyString: 			.asciiz "\n"
	horizLine:			.asciiz "\t---------\n"
	vertLine:			.asciiz "|"
	tabOver:			.asciiz "\t"
	
	# Variables for gameModule.asm
	nineFile:			.asciiz "wordlistnine.txt"
	nineBuffer:			.space  72			
	displayTime:			.asciiz "\nTime remaining: "
	timeOutMsg:			.asciiz	"\n############################################# ~TIME UP~ ################################################\n"
	startTime:			.word	0
	displayWord:			.space 10
	readErrorMsg: 			.asciiz "\nError in reading file.\n"
	endFileRead:			.asciiz "\nEnd of file read"
	pointTotal:			.asciiz "\nTotal Points: "
	
	# Variables for UserInput
	inputStr:			.space 10
	inputPrompt:			.asciiz "\nEnter a word: "
	inputBuffer: 			.space 15
	exitStr:			.asciiz "X"
	shuffleStr:			.asciiz "S"
	newLineStr:			.asciiz "\n"
	notAWord:			.asciiz "\nSorry, that is not correct. Not a word, not correct length, not with middle character or already inputted word.\n"
	isAWord:			.asciiz "\nValid Word!\n"
	
	# Variables for Checking Dictionary
	inDictStr:			.asciiz "\nChecking...."
	afterDict:			.asciiz "\nAfter Dictionary!\n"
	prevWords:			.space 5000
	fourFile:			.asciiz "wordlistfour.txt"
	fourBuffer:			.space 	7
	fiveFile:			.asciiz "wordlistfive.txt"
	fiveBuffer:			.space 	8
	sixFile:			.asciiz "wordlistsix.txt"
	sixBuffer:			.space	9
	sevenFile:			.asciiz "wordlistseven.txt"
	sevenBuffer:			.space	10
	eightFile:			.asciiz "wordlisteight.txt"
	eightBuffer:			.space 	11
	
# Text Segment
.text										# Instructions follow this line
.globl main									# main symbol will be accessible from outside current file
	# Prepocessing section ~ Following user header files are included ~
	.include "gameModule.asm"
	.include "validationModule.asm"
	.include "timerAndPointModule.asm"
	.include "checkDictionary.asm"

	# Indicates start of the code
	main:
		# Display boot message
		li	$v0, 4							# Put service 4 into register $v0 which is used for print string
		la	$a0, borderMsg						# Load address of bootMsg into $
		syscall								# Read register $v0 for opcode, sees 4 and prints the string located in $a0
		# Continued
		la	$a0, bootMsg						# Load address of bootMsg into $a0
		syscall								# Read register $v0 for opcode, sees 4 and prints the string located in $a0
		# Continued
		la	$a0, borderMsg
		syscall
		# Display selection message
		la	$a0, selectMsg
		syscall
		# Display new game message
		la	$a0, newGameMsg
		syscall
		# Display how to play message
		la	$a0, howToPlayMsg
		syscall
		# Display end game message
		la	$a0, endGameMsg
		syscall
		# Display selection
		la	$a0, inputSelectMsg
		syscall
		# Get user input
		li	$v0, 5							# Put service 5 into register $v0 which is used to read integer
		syscall								# Reads register $v0 for opcode, sees 5 and waits for integer input
		# Branch section
		beq	$v0, 1, start						# Go to start if selection is 1 
		beq	$v0, 2, help						# Go to help section if selection is 2
		beq	$v0, 3, exit						# Exit game if selection is 3
		j	exit							# Jump to exit label
		
#-------------------START-------------------------------------#
	start:
		li	$v0, 4
		la	$a0, borderMsg
		syscall
		# Continued
		la	$a0, gameHeader
		syscall
		# Continued
		la	$a0, borderMsg
		syscall
		# Continued
		la 	$a0, instructionMsg11
		syscall
		
		jal	getDisplayWord				# Display Grid
		jal	beginCountdown				# Start countdown timer
		jal	checkTime				# Retrieve remaining time			
		jal	userInput				# Gets user input
		j exit

#--------------------------------------------------------------#

	# Display help instructions
	help:
		li	$v0, 4
		la	$a0, borderMsg
		syscall
		# Continued
		la	$a0, helpMsg
		syscall
		# Continued
		la	$a0, borderMsg
		syscall
		# Continued
		la	$a0, instructionMsg1
		syscall
		# Continued
		la	$a0, instructionMsg2
		syscall
		# Continued
		la	$a0, instructionMsg3
		syscall
		# Continued
		la	$a0, instructionMsg4
		syscall
		# Continued
		la	$a0, instructionMsg5
		syscall
		# Continued
		la	$a0, instructionMsg6
		syscall
		# Continued
		la	$a0, instructionMsg7
		syscall
		# Continued
		la	$a0, instructionMsg8
		syscall
		# Continued
		la	$a0, instructionMsg9
		syscall
		# Continued
		la	$a0, instructionMsg10
		syscall
		# Branch section
		li 	$v0, 5
		syscall
		bne	$v0, -1, main
	
	exit:
		# Display End Points
		li 	$v0, 4
		la 	$a0, pointTotal
		syscall
		li 	$v0, 1
		addi 	$a0, $s4, 0
		syscall
		li	$v0, 4
		la 	$a0, newLine
		syscall
		# Display Game over
		li	$v0, 4
		la	$a0, borderMsg
		syscall
		# Continued
		la	$a0, gameOverMsg
		syscall
		# Continued
		la	$a0, borderMsg
		syscall
		# Exit call
		li	$v0, 10								
		syscall
		
