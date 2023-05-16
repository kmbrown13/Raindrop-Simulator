.data #data section

#Keeps track of equivalent constant values for the domain and range constants in the C
#version of my project
	.eqv DOMAIN 5
	.eqv RANGE 25
	.eqv NUMDROP 2				#equivalent value for number of raindrops - 1

#section for all of my prompt strings
	charPrompt: .asciiz "Please enter a character. Press 'p' to play or 'e' to exit.\n"
	dropPrompt: .asciiz "\nSelect a raindrop to play. Choose a number 1-3 to select your raindrop.\n"
	selectionError: .asciiz "\nPlease enter a valid number. Choose a number 1-3 to select your raindrop.\n"
	winPrompt: .asciiz "\nYou selected the right raindrop! You win!\n"
	losePrompt: .asciiz "\nYour drop didn't win. You lose :(\n"

#Initialized 2D Array (Can be adjusted to fit the size needed for storing all function results)
	.align 2
	outputArray:
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5
		.byte ' ':5

.text #code section

#main (parent) function
	main:
		li $s0, 0					#initializes $s0 register to 0 for storing the user's selected raindrop (mainly for reset)
		
		#prompts the user to enter a character, then receives that input
		li $v0, 4
		la $a0, charPrompt
		syscall
		li $v0, 12
		syscall
		move $t0, $v0
		
		#if $t0 == 'p,' then the code jumps to the gameLoop. if $t0 == 'e,' then the program exits.
		#if the character is invalid, then the game reprompts the user to enter a character.
		beq $t0, 'p',  gameLoop
			#code segment for printing a newline
			li $v0, 11
			la $a0, '\n'
			syscall
		
		#if the user inputs 'e' then the program terminates				
		bne $t0, 'e', main
		j exit
		
		#code segment for the game loop
		gameLoop:
			
			dropWhile:
			#prompts the user with dropPrompt, then receives the user's chosen raindrop value
				li $v0, 4
				la $a0, dropPrompt
				syscall
				li $v0, 5
				syscall
				move $t1, $v0
			
			#checks if user's chosen value is valid. if it is, then dropWhile is not entered
				beq $t1, 1, dropSimulation		
				beq $t1, 2, dropSimulation
				bne $t1, 3, dropWhile
			
				dropSimulation:
					move $s0, $t1
					jal outputGraph
		
		#checks if the win flag == 1. If it isn't then the loss prompt is output, else the win prompt is output
			bne $s1, 1, displayLoss
			li $v0, 4
			la $a0, winPrompt
			syscall
			
			#code segment for generating sound
			li $v0, 31
			la $a0, 75
			la $a1, 500
			la $a2, 114
			la $a3, 127
			syscall
			
			j ResetLoop
		
			displayLoss:
				li $v0, 4
				la $a0, losePrompt
				syscall
		
			ResetLoop:
				li $t6, 0					#initializes counter for outer loop of printing output graph
				la $t5, outputArray			#loads base address of outputArray into $t5
		
			outerResetLoop:
				bge $t6, DOMAIN, exitReset
				li $t7, 0					#initializes counter for inner loop of printing output graph
		
			innerResetLoop:
				bge $t7, RANGE, exitInnerResetLoop
				mul $t8, $t6, RANGE			#$t8 = DOMAIN * currentRow
				add $t8, $t8, $t7			#t$8 = $t8 + currentColumn
				add $t8, $t5, $t8			#$t8 = $t8 + base address of outputGraph
		
				la $a0, ' '					#loads address of ' ' character into $a0
				sb $a0, ($t8)				#stores '\' character into the adress stored in $t8
		
				add $t7, $t7, 1				#increments counter for inner loop by 1
				j innerResetLoop
		
			exitInnerResetLoop:
				add $t6, $t6, 1				#increments counter for outer loop by 1
		
			j outerResetLoop
		
			exitReset:
			
				#code segment for printing a newline
				li $v0, 11
				la $a0, '\n'
				syscall
			
				j main
	#code segment for terminating program
		exit:
			li $v0, 10
			syscall
		
#outputGraph child function
	outputGraph:

		addi $sp, $sp, -8			#allocates space on the stack for storing the $ra register
		sw $ra, 0($sp)				#stores $ra register on the first allocated stack location
	
		jal randomizeDrop			#jump and links from the outputGraph function to the PRNG function
		
		lw $ra, 0($sp)				#restores the $ra register off the stack
		addi $sp, $sp, 8			#restores allocated space on the stack
		
		li $t6, 0					#initializes counter for outer loop of printing output graph
		la $t5, outputArray			#loads base address of outputArray into $t5
		
		outerOutputGraphLoop:
		bge $t6, DOMAIN, exitOutputGraph
		li $t7, 0					#initializes counter for inner loop of printing output graph
		
		innerOutputGraphLoop:
		bge $t7, RANGE, exitInnerOutputGraphLoop
		mul $t8, $t6, RANGE			#$t8 = DOMAIN * currentRow
		add $t8, $t8, $t7			#$t8 = $t8 + currentColumn
		add $t8, $t5, $t8			#$t8 = $t8 + base address of outputGraph
		
		#code segment for outputting a character followed by a space
		li $v0, 11
		lb $t8, ($t8)				#loads the character at address stored in $t8 into $t8
		la $a0, ($t8)				#loads that character in $t8 into the argument register $a0
		syscall
		li $v0, 11
		la $a0, ' '					
		syscall
		
		add $t7, $t7, 1				#increments the counter for the inner loop by 1
		j innerOutputGraphLoop
		
		exitInnerOutputGraphLoop:
		add $t6, $t6, 1				#increments the counter for the outer loop by 1
		
		#code segment that uses sleep syscall to delay outputting a newline
		li $v0, 32
		la $a0, 500
		syscall
		
		#code segment for printing a newline
		li $v0, 11
		la $a0, '\n'
		syscall
		
		j outerOutputGraphLoop
		
		exitOutputGraph:
		jr $ra
	
#randomizeDrop grandchild function
	randomizeDrop:
		li $t4, 0						#initializes counter for outermost loop
		li $s1, 0					#initializes $s1 register to 0 so it can function as a flag variable for the win condition
	
		outerRandomizeLoop:
			bge $t4, NUMDROP, exitRandomizer
	
			sw $ra, 4($sp)					#stores the $ra register at the second allocated stack location
	
			jal lfsr						#function call to the lfsr function
	
			lw $ra, 4($sp)					#restores the $ra register off the stack
	
			move $t9, $v1					#moves result from RNG into $t9
	
			bne $t9, 0, dropNCheck1			#checks if drop->n == 0
			bne $s0, 1, contDrop1
			addi $s1, $s1, 1
	
		contDrop1:
	
			li $t6, 0					#initializes counter for outer loop of printing output graph
			la $t5, outputArray
		
		outerRandomizer1Loop:
			bge $t6, DOMAIN, updateRandomizerCounter
		
			mul $t7, $t6, 1				#sets $t7 as y = x
		
			mul $t8, $t6, RANGE			#$t8 = DOMAIN * currentRow
			add $t8, $t8, $t7			#$t8 = $t8 + currentColumn
			add $t8, $t5, $t8			#$t8 = $t8 + base address of outputGraph
		
			la $a0, '*'					#loads address of '\' character into $a0
			sb $a0, ($t8)				#stores '\' character into the adress stored in $t8
		
			add $t6, $t6, 1				#increments 000000counter for randomizer loop #1 by 1
			j outerRandomizer1Loop
			
		exitOuterRandomizer1Loop:
		j updateRandomizerCounter
	
	dropNCheck1:
		bne $t9, 1, dropNCheck2			#checks if drop->n == 1
	
		li $t6, 0					#initializes counter for outer loop of printing output graph
		la $t5, outputArray
		
		outerRandomizer2Loop:
			bge $t6, DOMAIN, updateRandomizerCounter
		
			mul $t7, $t6, 5				#sets $t7 as y = 5x
		
			mul $t8, $t6, RANGE			#$t8 = DOMAIN * currentRow
			add $t8, $t8, $t7			#$t8 = $t8 + currentColumn
			add $t8, $t5, $t8			#$t8 = $t8 + base address of outputGraph
		
			la $a0, '*'					#loads address of '\' character into $a0
			sb $a0, ($t8)				#stores '\' character into the adress stored in $t8
		
			add $t6, $t6, 1				#increments counter for randomizer loop #1 by 1
			j outerRandomizer2Loop
			
		exitOuterRandomizer2Loop:
	
		#sleep syscall instruction for 100 ms
		li $v0, 32
		la $a0, 100
		syscall
	
		j updateRandomizerCounter
	
	dropNCheck2:
		bne $t9, 2, updateRandomizerCounter	#checks if drop->n == 2
	
		li $t6, 0					#initializes counter for outer loop of printing output graph
		la $t5, outputArray
		
		outerRandomizer3Loop:
			bge $t6, DOMAIN, updateRandomizerCounter
		
			mul $t7, $t6, 3				#sets $t7 as y = 3x
		
			mul $t8, $t6, RANGE			#$t8 = DOMAIN * currentRow
			add $t8, $t8, $t7			#$t8 = $t8 + currentColumn
			add $t8, $t5, $t8			#$t8 = $t8 + base address of outputGraph
		
			la $a0, '*'					#loads address of '\' character into $a0
			sb $a0, ($t8)				#stores '\' character into the adress stored in $t8
		
			add $t6, $t6, 1				#increments counter for randomizer loop #1 by 1
			j outerRandomizer3Loop
		
		exitOuterRandomizer3Loop:
		
		#sleep syscall instruction for 200 ms
		li $v0, 32
		la $a0, 200
		syscall
	
		updateRandomizerCounter:
			add $t4, $t4, 1				#increments counter for outer loop by 1
			j outerRandomizeLoop
	
	exitRandomizer:
	jr $ra

#CODE SEGMENT FOR LFSR FUNCTION (FROM HW4) CALL
	lfsr:								#$a0 stores the seed value, $t0 stores the lfsr value, and $t1 stores the bit value, and $t2
									#stores the temporary calculated value
	
		li $v0, 30							#loads the system time as the seed for the lfsr prng
		syscall
	
		move $t0, $a0						#stores the seed value in the lfsr value
	
		#segment for calculating the bit value
		srl $t1, $t0, 0						#logical shifts right lfsr value by 0
		srl $t2, $t0, 10						#logical shifts right lfsr value by 10
		xor $t1, $t1, $t2					#xors saved bit value with the temporary value in $t2
		srl $t2, $t0, 30						#logical shifts right lfsr value by 30
		xor $t1, $t1, $t2					#xors saved bit value with the temporary value in $t2
		srl $t2, $t0, 31						#logical shifts right lfsr value by 31
		xor $t1, $t1, $t2					#xors saved bit value with the temporary value in $t2
		and $t1, $t1, 1						#adds 1 using the logical and operator
	
		#segment for calculating the lfsr value
		srl $t2, $t0, 1						#logical shifts right lfsr value by 1
		sll $t1, $t1, 31						#logical shifts left bit value by 31
		or $t0, $t2, $t1						#updates the lfsr value with the logical or of the lfsr value and bit value
	
		#segment for dividing the lfsr value and getting the remainder (NEW CODE DIFFERENT THAN THE HOMEWORK)
		rem $t0, $t0, 3
	
		bge $t0, 0, lfsrExit					#if the rng value is negative then it is made positive
		mul $t0, $t0, -1	
		###END NEW CODE DIFFERENT THAN THE HOMEWORK###
		
		lfsrExit:
			move $v1, $t0						#passes the remainder value outside of the function call
			jr $ra
