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
  # Setting address of board array
  la $s0, boardArr
  # li $s2, 0 # index

  # Save return address and any registers to the stack
  addi $sp, $sp, -8
  sw   $ra, 0($sp)
  sw   $s0, 4($sp)

  # Print the board
  jal printBoard

  # Prompt the user (P1 or P2)
  jal promptUser

  # Restore return address and any registers from the stack
  lw   $s0, 4($sp)
  lw   $ra, 0($sp)
  addi $sp, $sp, 8

  # Terminate program
  li $v0, 10
  syscall

### FXN: Prompting the user
promptUser:
  li $v0, 4
  la $a0, P1move 
  syscall

  li $v0, 4
  la $a0, pickmove
  syscall

  ### Reading user input
  li $v0, 5 
  syscall
  move $t0, $v0

  ### Return to calling function
  jr $ra

### FXN: Change state to P1
P1Print:
 li $s3, 1 #player 1

 li $v0, 4
 la $a0, P1move 
 syscall

### FXN: Change state to P2
 P2Print:
  li $s3, 2 #player 2

  li $v0, 4
  la $a0, P2move 
  syscall

### FXN: PRINT THE BOARD
printBoard:
  # holds index of current element
  li $t0, 0

  printLoop:
    ### current element
    li $v0, 1 # syscall number to print an integer
    lw $a0, boardArr($t0) # load current element into $s2
    syscall

    ### separator
    li $v0, 11 # syscall number to print a character
    li $a0, 0x7C # '|'
    syscall

    ### increment index by 4 bytes
    addi $t0, $t0, 4
    blt $t0, 36, printLoop # until all elements printed

    ### Return to calling function
    jr $ra
  
### TODO FXN: PLACE PIECE ON BOARD
setPiece:
  mul $t1, $t0, 4
  add $t4, $s0, $t1# add $s1, $t1, $s0 # $t4 = new index + $s0 -> we are adding the index to the location of our array (to get where we want the data teehee)
  lw $t3, 0($t4) #0($t1) # $t3 = A[i], so now we have $t3 is our value in the array (time to test if it is zero or another number)

  bne $s3, 1, P2 #which player is it?

P1: 
 bne $t3, 0, P1Print #not empty
 sw $s3, 0($t4)

  li $v0, 4
  la $a0, confirm 
  syscall
  
  jal P2Print

P2:
 bne $t3, 0, P2Print
 sw $s3, 0($t4)

  li $v0, 4
  la $a0, confirm 
  syscall

  jal P1Print