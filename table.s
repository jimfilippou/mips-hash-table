.data
	crlf:		.asciiz	"\n"
	.align 2
	hash:		.space	40
	N:		.word	10
	key:		.word	0
	keys:		.word	0
	pos:		.word	0
	choice:		.word	0
	telos:		.word	0
	menu:		.asciiz "Menu\n"
	insertKey:	.asciiz "1.Insert key"
	findKey:	.asciiz "2.Find key"
	displayTable:	.asciiz "3.Display Hash Table"
	exit:		.asciiz "4.Exit"
	choose:		.asciiz "\nChoose operation:"

.text
.globl main

main:
	
	lw	$s0,	N		# N    = 10 
	lw 	$s1,	keys		# keys = 0
	
	lw	$t0,	key		# key    = 0
	lw 	$t1,	pos		# pos    = 0
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
	li	$v0,	4
	la	$a0,	insertKey
	syscall
	li	$v0,	4
	la	$a0,	findKey
	syscall
	li	$v0,	4
	la	$a0,	displayTable
	syscall
	li	$v0,	4
	la	$a0,	exit
	syscall
	
	# Get user input
	li	$v0,	4
	la	$a0,	choose	
	syscall
	li	$v0,	5	# Read user input
	syscall
	move 	$t7,	$v0	# $t7 = readInt();
	
	# At this point, $t4 + $t5 + $t6 are available for use
	
	addi	$t4,	$zero,	1		# $t4 = 1
	beq	$t7,	$t4,	insert		# if (choice == 1)
	addi	$t4,	$zero,	2		# $t4 = 2
	beq	$t7,	$t4,	find		# if (choice == 2)
	addi	$t4,	$zero,	3		# $t4 = 3
	beq	$t7,	$t4,	show		# if (choice == 3)
	addi	$t4,	$zero,	4		# $t4 = 4
	beq	$t7,	$t4,	terminate	# if (choice == 4) exit;
	
	j	continue
	
insert:
find:
show:

terminate:

	li $v0,10
	syscall
		
		
		
		

