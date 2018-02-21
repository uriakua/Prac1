.data

.text
	#reserve memory starting on 10010000 as instrcuted on the file, this is where the disks will be loaded
	addi $a1, $zero, 0x10010000	#first rod
	addi $a2, $zero, 0x10010020	#second rod
	addi $a3, $zero, 0x10010040	#third rod
	
	addi $s0, $zero, 8	#number of disks n
				
fillrod:	
	#fill the first rod with n disk 			
	sw $s0, 0($a1)			#store disk n, n-1, n-2, n-3, n... on first pole
	addi $s0, $s0, -1		#decrease number of disk by one n-1
	addi $a1, $a1, 4		#move to next space on memory
	bne $s0, $zero, fillrod		#if n != 0 return to fillrod until all disks are stored on rod	 
				
	
exit
	