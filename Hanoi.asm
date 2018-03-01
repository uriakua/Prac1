.data

.text
	#reserve memory starting on 10010000 as instrcuted on the file, this is where the disks will be loaded
	addi $a1, $zero, 0x10010000	#first rod	A, origin
	addi $a2, $zero, 0x10010020	#second rod	B, aux
	addi $a3, $zero, 0x10010040	#third rod	C, destiny
	
	addi $s0, $zero, 4	# number of discs n
	add $t0, $s0, $zero	# number of discs on A
	addi $t4, $zero, 1	# this is used for the flag as a slti
				
fillrod:	
	#fill the first rod with n disk 			
	sw $t0, 0($a1)			# store disk n, n-1, n-2, n-3, n... on first pole A
	addi $t0, $t0, -1		# n-1 this is used to avoid modifying $s0
	addi $a1, $a1, 4		#move to next space on memory
	bne $t0, $zero, fillrod		#if n != 0 return to fillrod until all disks are stored on first rod A	 
	
	jal saveStack		
	j exit
	
saveStack:
	#move discs from A to be using C as an aux
	addi $sp, $sp, -8	# reserve 2 spaces on stack 
	sw $ra, 0($sp)		# store return address in stack
	sw $s0, 4($sp)		# store number of discs in stack  #towers dissapear
	
	#sw $t5, 8($a1)		#this is only used to show the rods and discs at all times
		
				
	beq $s0,$t4, printDiscs	# when all discs from A are moved to B go to printDiscs 
				
	addi $s0, $s0, -1	# number of discs -1 
	
moveBtoC:		
	add $t1, $a2, $zero 	# store old B in temp 1
	add $a2, $a3, $zero	# move C to B
	add $a3, $t1, $zero	# move old B to C	
		
	jal saveStack		#  saveStack
	
	add $t8, $t8, $t4	# flag indicator
	
	add $t1, $a2, $zero	# Store old B on T1	
	add $a2, $a3, $zero	# Move C to B	
	add $a3, $t1, $zero 	# Move old B to C	
	

printDiscs:
	# this is used to see in memory the movement of the discs 

	addi $a1, $a1, -4	# move to the previous value of A
	lw $t3,0($a1)		# load in temp 3 A
	sw $zero, 0($a1)	# clean n-1 from A
	sw $t3, 0($a3)		# store in temp 3 C (move A to C)
	addi $a3, $a3, 4	# move to next value on C
	bne $t8, $zero, moveAtoB	# while temp 8 != 0 do go to move A to B moveAtoB label
	
	
	addi $sp, $sp, 8	# return to previos space on stack
	
	jr $ra			# jump to return address
moveAtoB:
	# this is used to move A to B
	add $t8, $zero, $zero	# set flag to zero
	lw $s0, 4($sp)		# load number of discs
	addi $s0, $s0, -1	# number of discs -1
	
	beq $s0, $zero, baseCase
moveBtoA:	
	add $t1, $a1, $zero	# save on temp1 the value of old A	
	add $a1, $a2, $zero	# Fill A with B
	add $a2, $t1, $zero 	# Fill B with old A	  
		
	jal saveStack		# jump to saveStack
	
	
	lw $ra, 0($sp)		# load the return address
	add $t2, $a1, $zero	# save on temp 2 old A	 
	add $a1, $a2, $zero	# move B to A	
	add $a2, $t2, $zero	# move old A to B	
	
	addi $sp, $sp, 8	# move to previous space on stack
	
	jr $ra			# back to register address

baseCase:
	
	

exit:

	
