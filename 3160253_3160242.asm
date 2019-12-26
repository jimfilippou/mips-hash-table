# *------------------------------*
# | Authors:                     |
# | 3160253 - Dimitris Filippou  |
# | 3160242 - Leonidas Velentzas |
# *------------------------------*

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
    diplayTemplate: .asciiz "\npos key\n"
    choose:         .asciiz "\nChoose operation:"
    askKey:         .asciiz "Give key to search for: "
    notInTableStr:  .asciiz "Key not in hash table.\n"
    giveKey:        .asciiz "Give a new key (greater than zero): "
    lessThanZero:   .asciiz "Key must be greater than zero"
    alreadyIn:      .asciiz "Key is already in hash table.\n"
    hashFull:       .asciiz "Hash table is full.\n"
    debugMessage:   .asciiz "edo"

.text
.globl main

main:

    lw      $s0,    N                   # N      = 10
    lw      $s1,    keys                # keys   = 0
    lw      $t0,    key                 # key    = 0
    lw      $t1,    pos                 # pos    = 0
    lw      $t2,    choice              # choice = 0
    lw      $t3,    telos               # telos  = 0

    addi    $t4,    $zero,  0           # $t4 = 0 (for counter)
    addi    $t5,    $zero,  0           # $t5 = 0 (index for array, adds 4 every time)
    addi    $t6,    $zero,  0           # $t6 = 0 (used for filling array, never changes)

for:
    bge     $t4,    $s0,    continue	# Check condition of 'for'
    sw      $t6,    hash($t5)	        # Store '0' at $t5 index
    addi    $t5,    $t5,    4           # Increment index
    addi    $t4,    $t4,    1           # Increment for iterable
    j       for                         # Cintinue for

continue:

    la      $a0,    menu      # Supply string argument
    jal     print             # Jump and link to print helper (for strings only)

    la      $a0,    choose    # Supply string argument
    jal     print             # Jump and link to print helper (for strings only)

    li	    $v0,    5         # Prepare to read user input
    syscall                   # Execute

    move    $t7,    $v0       # $t7 = $v0 (readInt)

    # *----------------------------------------*
    # |           Start control flow           |
    # *----------------------------------------*
    beq     $t7,    1,    prepareToInsert
    beq     $t7,    2,    prepareToFindKey
    beq     $t7,    3,    prepareToDisplayTable
    beq     $t7,    4,    terminate
    # *----------------------------------------*
    # |           End control flow             |
    # *----------------------------------------*

    prepareToInsert:
        la      $a0,    giveKey                      # Supply string argument
        jal     print                                # Jump and link to print helper (for strings only)
        jal     readInt                              # Jump and link to readInt helper returns .word on addr $v0
        move    $t4,    $v0                          # Save returned word to $t4
        blt     $t4,    $zero,    keyLessThanZero
        move    $a0,    $t4                          # Supply string argument
        jal     insertKey                            # Jump and link to insertKey with just $a0
        
        keyLessThanZero:
            la    $a0,    lessThanZero
            jal   print
            j     continue


    prepareToDisplayTable:
        lw      $a0,    hash
        jal     displayTable
        j       continue
    
    prepareToFindKey:
        la      $a0,    askKey                       # Supply string argument
        jal     print                                # Jump and link to print helper (for strings only)
        jal     readInt                              # Jump and link to readInt helper returns .word on addr $v0
        move    $t4,    $v0
        move    $a0,    $t4                # Pass argument: key to find
        lw      $a1,    hash               # Pass argument: hash
        jal     findKey                    # Execute findKey
        move    $t8,    $v0                # Store output to $t8
        beq     $t8,    -1,    notInTable  # If ($t8 == -1)

        notInTable:
            la      $a0,    notInTableStr
            jal     print


    # At this point, $t4 is available for use

    j       continue


# *------------------------------------------------------------------------------*
# | This function is of void type, even though it is called with jal. When this  |
# | function terminates, $ra is being reset to $zero and the menu loop continues.|
# *------------------------------------------------------------------------------*
insertKey:

    move    $t4,    $a0            # $t4 = $a0 = k (Argument passed)
    addi    $t5,    $zero,    0    # $t5 = 0 (position)

    move    $a0,    $t4            # Supply argument to findKey
    jal     findKey                # Jump and link to findKey with one argument
    move    $t5,    $v0            # Store result to $t5 (position)

    bne     $t5,    -1,       keyAlreadyInTable
    bge     $s1,    $s0,      hashTableFull

    move    $a0,    $t4            # Supply argument to hashFunction
    jal     hashFunction           # Jump and link to hashFunction with one argument
    move    $t5,    $v0            # Store result to $t5 (position)

    mul     $t6,    $t5,      4    # $t6 = $t5 * 4 for .word indexing
    sw      $t4,    hash($t6)      # Store word $t4 on hash[$t6]
    addi    $s1,    $s1,      1    # $s1++ or keys++

    move    $ra,    $zero
    j       continue               # Finish and return to return address

    hashTableFull:
        la      $a0,    hashFull
        li      $v0,    4
        syscall
        move    $ra,    $zero
        j       continue 

    keyAlreadyInTable:
        la      $a0,    alreadyIn
        li      $v0,    4
        syscall
        move    $ra,    $zero
        j       continue 

hashFunction:
    move  $t4,    $a0              # int k (argument)
    addi  $t5,    $zero,    1      # int position = 0
    rem   $t5,    $t4,      $s0    # position = k % N
    
    hashWhile:
        mul     $t6,    $t5,      4             # $t6 = position * 4
        lw      $t7,    hash($t6)               # $t7 = hash[position] return position
        beq     $t7,    $zero,    returnPos     # If hash[$t6] == 0
        addi    $t5,    $t5,      1             # $t5++
        rem     $t5,    $t5,      $s0           # $t5 %= N
        j       hashWhile
    
    returnPos:
        move    $v0,    $t5    # Return position
        jr      $ra            # Jump to return address

findKey:
    addi    $t4,    $zero,    0             # $t4 = 0 (position)
    addi    $t5,    $zero,    0             # $t5 = 0 (i)
    addi    $t6,    $zero,    0             # $t6 = 0 (found)
    move    $t7,    $a0                     # [ERROR] $t7 = Argument (k) IS ZERO
    rem     $t4,    $t7,      $s0           # $t4 = $a1 % $s0 (position = k % N)

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
        jr     $ra                          # return

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
        
        #la      $a0,    crlf    # Why this doesn't work?
        #jal     print           # Why this doesn't work? 
        la      $a0,    crlf
        li      $v0,    4
        syscall

        addi    $t4,    $t4,    1
        addi    $t5,    $t5,    4
        j       displayFor
    displayExit:
        jr     $ra


# *------------------*
# | Helper functions |
# *------------------*

printInteger:
    li      $v0,    1
    syscall
    jr      $ra

print:
    li      $v0,    4
    syscall
    jr      $ra

readInt:
    li      $v0,    5
    syscall
    jr      $ra

debugThis:
    li      $v0,    4
    la      $a0,    debugMessage
    syscall
    jr      $ra

# *------------------*
# | End of execution |
# *------------------*
terminate:
    li    $v0,    10
    syscall





