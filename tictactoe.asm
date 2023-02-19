  .data

### PLAYER 1's TURN MSG
P1move: .asciiz "PLAYER 1 MOVE \n"
### PLAYER 2's TURN MSG
P2move: .asciiz "PLAYER 2 MOVE \n"

### Array for gameboard
boardArr: .word 0, 1, 2, 3, 4, 5, 6, 7, 8
boardSize: .word 9

### Prompt for move
pickmove: .asciiz "Pick a spot to play (0-8)\n"

### PROGRAM
  .text
  .globl main

main:
  la $s0, boardArr # Setting address of board array
  li $s2, 0 # Set game to NOT over
  li $s3, 1 # Set current player to 1

  # Save return address and any registers to the stack
  addi $sp, $sp, -8
  sw   $ra, 0($sp)
  sw   $s0, 4($sp)

  gameLoop:
    # Prompt the user (P1 or P2)
    jal promptUser

    # Print the board
    jal printBoard

    # Switch current player state (negate)
    sub $s3, $zero, $s3

    beq $s3, 0, gameLoop # until all elements printed

  # Restore return address and any registers from the stack
  lw   $s0, 4($sp)
  lw   $ra, 0($sp)
  addi $sp, $sp, 8

  # Terminate program
  li $v0, 10
  syscall

### FXN: Prompting the user
promptUser:
  # If player 1 -> print player 1 turn
  beq $s3, 1, P1Turn

  # If player 2 -> print player 2 turn
  beq $s3, -1, P2Turn

  # Print "pick a move prompt" 
  li $v0, 4
  la $a0, pickmove
  syscall

  # Read user input
  li $v0, 5 
  syscall
  move $t0, $v0 # store user's input into t0 reg

  # Finding address of spot user wants
    # t4 is address of spot
  mul $t1, $t0, 4
  add $t4, $s0, $t1 # add $s1, $t1, $s0 # $t4 = new index + $s0 -> we are adding the index to the location of our array (to get where we want the data teehee)
  lw $t3, 0($t4) # 0($t1) # $t3 = A[i], so now we have $t3 is our value in the array

  # Check if move is valid (empty spot)
    # if not valid -> reprompt
  lw $t5, boardArr($t4)
  bne $t5, $zero, promptUser

  sw $s3, 0($t4) # store player's position in spot

  # Return to calling function
  jr $ra

### FXN: Print msg indicating it is player 1's turn
P1Turn:
  # Print it is P1's turn 
  li $v0, 4
  la $a0, P1move 
  syscall
  
### FXN: Print msg indicating it is player 2's turn
P2Turn:
  # Print it is P2's turn
  li $v0, 4
  la $a0, P2move 
  syscall

### FXN: PRINT THE BOARD
printBoard:
  li $t0, 0 # holds index of current element
  li $t1, 0 # counter of elements processed

  printLoop:
    ### current element
    li $v0, 1 # syscall number to print an integer
    lw $a0, boardArr($t0) # load current element
    syscall

    ### separator
    li $v0, 11 # syscall number to print a character
    li $a0, 0x7C # '|'
    syscall
    
    ### newline every third element
    # addi $t1, $t1, 1 # update counter
    # rem $t2, $t1, 3
    # beqz $t2, newline

    ### increment index by 4 bytes
    addi $t0, $t0, 4
    blt $t0, 36, printLoop # until all elements printed

    ### Return to calling function
    jr $ra

#newline:
#  li $v0, 11 
#  li $a0, '\n'
#  syscall