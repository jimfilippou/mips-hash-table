# 3160253 - Dimitris Filippou
# 3160242 - Leonidas Velentzas

.data
	crlf:			.asciiz	"\n"
	.align 2
	hash:			.space	40
	N:				.word	10
	key:			.word	0
	keys:			.word	0
	pos:			.word	0
	choice:			.word	0
	telos:			.word	0
	menu:			.asciiz "Menu\n1.Insert key\n2.Find key\n3.Display Hash Table\n4.Exit\n"
	diplayTemplate:	.asciiz	"\npos key\n"
	choose:			.asciiz "\nChoose operation:"

.text
.globl main

main:
	
	lw	$s0,	N			# N    = 10 
	lw 	$s1,	keys		# keys = 0
	
	lw	$t0,	key			# key    = 0
	lw 	$t1,	pos			# pos    = 0
	lw 	$t2,	choice		# choice = 0
	lw 	$t3,	telos		# telos  = 0
	
	addi	$t4,	$zero,	0	# $t4 = 0 (for counter)
	addi 	$t5,	$zero,	0	# $t5 = 0 (index for array, adds 4 every time)
	addi	$t6,	$zero,	0	# $t6 = 0 (used for filling array, never changes)

for:	
	bge	$t4,	$s0,	continue	# Check condition of 'for'
	
	sw	$t6,	hash($t5)	# Store '0' at $t5 index
	
	addi 	$t5,	$t5,	4	# Increment index
	addi 	$t4,	$t4,	1	# Increment for iterable
	
	j	for
	
continue:
	
	# Print the menu
	li	$v0,	4
	la	$a0,	menu
	syscall
	
	# Get user input
	li	$v0,	4
	la	$a0,	choose	
	syscall
	li	$v0,	5	# Read user input
	syscall
	move 	$t7,	$v0	# $t7 = readInt();
	
	# At this point, $t4 + $t5 + $t6 are available for use
	
	# Start control flow
	addi	$t4,	$zero,	1
	beq		$t7,	$t4,	insert			# if (choice == 1) go to insert
	addi	$t4,	$zero,	2
	beq		$t7,	$t4,	findKey			# if (choice == 2) go to find
	addi	$t4,	$zero,	3
	beq		$t7,	$t4,	displayTable	# if (choice == 3) go to show
	addi	$t4,	$zero,	4
	beq		$t7,	$t4,	terminate		# if (choice == 4) exit;
	# End control flow
	
	
	# At this point, $t4 is available for use
	
	j	continue
	

insert:

findKey:
	addi	$t4,	$t4,	0	# $t4 = position = 0
	addi	$t5,	$t5,	0	# $t5 = i = 0
	addi	$t6,	$t6,	0	# $t6 = found = 0

displayTable:
	addi	$t4,	$zero,	0
	addi	$t5,	$zero,	0
	displayFor:
		beq		$t4,	$s0,	terminate
		lw		$t6,    hash($t5)
		li		$v0,	1
		move	$a0,	$t4
		syscall
		li		$v0,	1
		move	$a0,	$t6
		syscall
		li		$v0,	4
		la		$a0,	crlf
		syscall
		addi	$t4,	$t4,	1
		addi	$t5,	$t5,	4
		j displayFor
	

terminate:

	li $v0,10
	syscall
		
		
		
		

