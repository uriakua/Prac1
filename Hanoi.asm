.data

.text
	#reserve memory starting on 10010000 as instrcuted on the file, this is where the disks will be loaded
	addi $a1, $zero, 0x10010000	#first rod
	addi $a2, $zero, 0x10010020	#second rod
	addi $a3, $zero, 0x10010040	#third rod
	
	addi $s0, $zero, 3	#number of disks n
	add $t0, $s0, $zero
	addi $t9, $zero, 1
				
fillrod:	
	#fill the first rod with n disk 			
	sw $t0, 0($a1)			#store disk n, n-1, n-2, n-3, n... on first pole
	addi $t0, $t0, -1		#decrease number of disk by one n-1
	addi $a1, $a1, 4		#move to next space on memory
	bne $t0, $zero, fillrod		#if n != 0 return to fillrod until all disks are stored on first rod	 
	
	jal hanoi		
	j exit
hanoi:

	addi $sp, $sp, -8	# reserve 2 spaces on stack 
	sw $ra, 0($sp)		# store return address in stack
	sw $s0, 4($sp)		# store number of discs in stack  #towers dissapear
		
	beq $s0,$t9, baseCase	# while n !=0 do hanoi
		
				
baseCase:
	

exit:

	
