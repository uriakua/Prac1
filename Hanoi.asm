####### Hanoi Towers ||| Made by Guillermo Roldan Gomez #######
.data

.text
	#reserve memory starting on 10010000 as instrcuted on the file, this is where the disks will be loaded
	addi $a1, $zero, 0x10010000	#first rod	A, origin
	addi $a2, $zero, 0x10010020	#second rod	B, aux
	addi $a3, $zero, 0x10010040	#third rod	C, destiny
	
	addi $s0, $zero, 8	# number of discs n
	add $t0, $s0, $zero	# this is used to fill the rod A
	addi $t4, $zero, 1	# this is used as a flag to compensate for the lack of slti, this is used to alternate between moving A and B
				
fillrod:	
	#fill the first rod with n disk 			
	sw $t0, 0($a1)			# store disk n, n-1, n-2, n-3, n... on first pole A
	addi $t0, $t0, -1		# n-1 this is used to avoid modifying $s0
	addi $a1, $a1, 4		#move to next space on memory
	bne $t0, $zero, fillrod		#if n != 0 return to fillrod until all disks are stored on first rod A	 
	
	
saveStack:
	#move discs from A to be using C as an aux
	addi $sp, $sp, -8	# reserve 2 spaces on stack 
	sw $ra, 0($sp)		# store return address in stack
	sw $s0, 4($sp)		# store number of discs in stack  
	beq $s0,$t4, printDiscs	# when all discs from A are moved to B go to printDiscs 
				
	
moveBtoC:		
	addi $s0, $s0, -1	# number of discs -1 
	add $t1, $a2, $zero 	# store old B in temp 1
	add $a2, $a3, $zero	# move C to B
	add $a3, $t1, $zero	# move old B to C	
		
	jal saveStack		#  saveStack

changeFlag:		
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
	bne $t8, $zero, resetFlag	# while temp 8 != 0 do go to move A to B resetFlag label
	
	addi $sp, $sp, 8	# return to previos space on stack
	jr $ra			# jump to return address
	
resetFlag:
	# this is used to move A to B
	add $t8, $zero, $zero	# set flag to zero
	lw $s0, 4($sp)		# load number of discs
	addi $s0, $s0, -1	# number of discs -1
	
	#beq $s0, $zero, baseCase
moveBtoA:	
	add $t1, $a1, $zero	# save on temp1 the value of old A	
	add $a1, $a2, $zero	# Fill A with B
	add $a2, $t1, $zero 	# Fill B with old A	  
		
	jal saveStack		# jump to saveStack
	
moveAtoB:	
	add $t2, $a1, $zero	# save on temp 2 old A	 
	add $a1, $a2, $zero	# move B to A	
	add $a2, $t2, $zero	# move old A to B	
	lw $ra, 0($sp)		# load the return address
	addi $sp, $sp, 8	# move to previous space on stack
	
	jr $ra			# back to register address

exit: