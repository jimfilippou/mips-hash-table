# 3160253 - Dimitris Filippou
# 3160242 - Leonidas Velentzas

.data
    crlf:           .asciiz "\n"
    .align 2
    hash:           .space  40
    N:              .word   10
    key:            .word   0
    keys:           .word   0
    pos:            .word   0
    choice:         .word   0
    telos:          .word   0
    menu:           .asciiz "Menu\n1.Insert key\n2.Find key\n3.Display Hash Table\n4.Exit\n"
    diplayTemplate: .asciiz	"\npos key\n"
    choose:         .asciiz "\nChoose operation:"
    askKey:         .asciiz "Give key to search for"
    notInTableStr:  .asciiz "Key not in hash table.\n"

.text
.globl main

main:

    lw      $s0,    N      # N    = 10
    lw      $s1,    keys   # keys = 0

    lw      $t0,    key    # key    = 0
    lw      $t1,    pos    # pos    = 0
    lw      $t2,    choice # choice = 0
    lw      $t3,    telos  # telos  = 0

    addi    $t4,    $zero,  0   # $t4 = 0 (for counter)
    addi    $t5,    $zero,  0   # $t5 = 0 (index for array, adds 4 every time)
    addi    $t6,    $zero,  0   # $t6 = 0 (used for filling array, never changes)

for:
    bge     $t4,    $s0,    continue	# Check condition of 'for'
    sw      $t6,    hash($t5)	        # Store '0' at $t5 index
    addi    $t5,    $t5,    4           # Increment index
    addi    $t4,    $t4,    1           # Increment for iterable
    j       for                         # Cintinue for

continue:

    # Print the menu
    li      $v0,    4
    la      $a0,    menu
    syscall

    # Get user input
    li      $v0,    4
    la      $a0,    choose
    syscall
    li	    $v0,    5       # Read user input
    syscall
    move    $t7,    $v0     # $t7 = readInt();

    # At this point, $t4 + $t5 + $t6 are available for use

    # Start control flow
    addi    $t4,    $zero,  1
    beq     $t7,    $t4,    insert
    addi    $t4,    $zero,  2
    beq     $t7,    $t4,    prepareToFindKey
    addi    $t4,    $zero,  3
    beq     $t7,    $t4,    prepareToDisplayTable
    addi    $t4,    $zero,  4
    beq     $t7,    $t4,    terminate
    # End control flow

    prepareToDisplayTable:
        lw      $a0,    hash
        jal     displayTable
        j       continue
    
    prepareToFindKey:
        li      $v0,    4
        la      $a0,    askKey
        syscall
        li      $v0,    5
        syscall
        move    $t4,    $v0
        
        lw      $a0,    hash    # Pass argument: hash
        move    $a1,    $t4     # Pass argument: key to find
        jal     findKey
        
        move    $t8,    $v0     # Store output to $t8

        beq     $t8,    -1,    notInTable

        notInTable:
            li      $v0,    4
            la      $a0,    notInTableStr
            syscall


    # At this point, $t4 is available for use

    j       continue


insert:

findKey:   
    addi    $t4,    $zero,    0             # $t4 = 0 (position)
    addi    $t5,    $zero,    0             # $t5 = 0 (i)
    addi    $t6,    $zero,    0             # $t6 = 0 (found)
    move    $t7,    $a1                     # $t7 = Argument (k)
    rem     $t4,    $a1,      $s0           # $t4 = $a1 % $s0 (position = k % N)

    while:
        bge    $t5,    $s0,    exitWhile    # If (i >= N)     exit while
        bne    $t6,    $zero,  exitWhile    # If (found !==0) exit while
        addi   $t5,    $t5,    1            # i++
        mul    $t3,    $t5,    4            # $t3 = i * 4 (Will hold array index)
        lw     $t2,    hash($t3)            # $t2 = hash[$t3]
        beq    $t2,    $t7,    found
        j      notFound
    
    found:
        addi    $t6,    $zero,    1         # found = 1
        j       exitWhile                   # Exit the while loop

    notFound:
        addi    $t4,    $t4,      1         # position++
        rem     $t4,    $t4,      $s0       # position %= N

    exitWhile:
        bne    $t6,    1,     returnMinusOne# prepare to return -1 (was not found)
        move   $v0,    $t4                  # set return value to position
        jr     $ra                          # jump to register and return

    returnMinusOne:
        addi   $v0,    $zero, -1            # set return value to return -1

    jr      $ra                             # return

displayTable:
    addi    $t4,    $zero,  0   # $t4 = 0 (for loop index)
    addi    $t5,    $zero,  0   # $t5 = 0 (array indexing)
    move    $t6,    $a0         # Passed but not used 
    displayFor:
        beq     $t4,    $s0,    displayExit
        lw      $t6,    hash($t5)
        li      $v0,    1
        move    $a0,    $t4
        syscall
        li      $v0,    1
        move    $a0,    $t6
        syscall
        li      $v0,    4
        la      $a0,    crlf
        syscall
        addi    $t4,    $t4,    1
        addi    $t5,    $t5,    4
        j       displayFor
    displayExit:
        jr     $ra


terminate:
    li    $v0,    10
    syscall





