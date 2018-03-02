	####### Hanoi Towers ||| Made by Guillermo Roldan Gomez #######
.data

.text
	# reserve memory starting on 10010000 as instrcuted on the file, this is where the disks will be loaded
	addi $a0, $zero, 0x10010000	#first rod	A, origin
	addi $a1, $zero, 0x10010020	#second rod	B, aux
	addi $a2, $zero, 0x10010040	#third rod	C, destiny
	
	addi $s0, $zero, 8	# n
	
	beq $s0, 1, baseCase	# base case
	add $t0, $s0, $zero	# this is used to fill the rod A
	addi $t4, $zero, 1	# this is used as a flag to compensate for the lack of slti, this is used to alternate between moving A and B
	addi $s1, $zero, 8	# saved tempo to increase or decrease memory
	addi $a3, $zero, 1	# argument to decrease variables	
	addi $s2, $zero, 4	# saved temp to increase or decrease level 
		
																										
fillrod:	
	# fill the first rod with n disk 			
	sw $t0, 0($a0)			# store disk n, n-1, n-2, n-3, n... on first pole A
	sub $t0, $t0, $a3		# n-1 reduce n to fill necessary discs
	add $a0, $a0, $s2		# move to next space on memory
	bne $t0, $zero, fillrod		# if n != 0 return to fillrod until all disks are stored on first rod A	 
	
		
saveStack:
	# move discs from A to be using C as an aux
	sub $sp, $sp, $s1	# move to next location on sp
	sw $ra, 0($sp)		# store ra in the first place of the stack
	sw $s0, 4($sp)		# save n on stack
	beq $s0,$t4, printDiscs	# when all discs from A are moved to B go to printDiscs 
				
	
moveBtoC:		
	# move B to C
	sub $s0, $s0, $a3	# number of discs -1 
	add $t1, $a1, $zero 	# store old B in temp 1
	add $a1, $a2, $zero	# move C to B
	add $a2, $t1, $zero	# move old B to C	
		
	jal saveStack		#  saveStack

changeFlag:		
	# change flag to 1
	add $t5, $t5, $t4	# flag indicator
	add $t1, $a1, $zero	# Store old B on T1	
	add $a1, $a2, $zero	# Move C to B	
	add $a2, $t1, $zero 	# Move old B to C	
	

printDiscs:
	# this is used to see in memory the movement of the discs 
	sub $a0, $a0, $s2	# move to the previous value of A
	lw $t3,0($a0)		# load in temp 3 A
	sw $zero, 0($a0)	# clean n-1 from A
	sw $t3, 0($a2)		# store in temp 3 C (move A to C)
	add $a2, $a2, $s2	# move to next value on C
	bne $t5, $zero, resetFlag	# while temp 8 != 0 do go to move A to B resetFlag label
	
	add $sp, $s1, $sp	# return to previos space on stack
	jr $ra			# jump to return address
	
resetFlag:
	# this is used to return the flag to 0
	add $t5, $zero, $zero	# set flag to zero	
	lw $s0, 4($sp)		# load number of discs
	sub $s0, $s0, $a3	# number of discs -1
	
moveBtoA:	
	# move B to A
	add $t1, $a0, $zero	# save on temp1 the value of old A	
	add $a0, $a1, $zero	# Fill A with B
	add $a1, $t1, $zero 	# Fill B with old A	  
		
	jal saveStack		# jump to saveStack
	
moveAtoB:	
	# move A to B
	add $t2, $a0, $zero	# save on temp 2 old A	 
	add $a0, $a1, $zero	# move B to A	
	add $a1, $t2, $zero	# move old A to B	
	lw $ra, 0($sp)		# load return address
	add $sp, $sp, $s1	# move to previous space on stack
	
	jr $ra			# jump tu return address
	j exit
	
baseCase:
	# base case when n = 1
	sw $s0, 0($a0)	# store on first space of rod A n
	sw $t4, 0($a0)	# store on temp 4 the value in rod A
	sw $s0, 0($a2)	# store in the first level of C 1
	j exit		# return 0
	
exit: