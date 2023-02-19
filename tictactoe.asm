  .data

### PLAYER 1's TURN MSG
P1move: .asciiz "PLAYER 1 MOVE \n"
### PLAYER 2's TURN MSG
P2move: .asciiz "PLAYER 2 MOVE \n" 

### Array for gameboard
boardArr: .word 0, 1, 2, 3, 4, 5, 6, 7, 8
boardSize: .word 9

### Gameboard to display
gameboard: .asciiz "0|1|2\n3|4|5\n6|7|8\n" 

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

  # Prompt the user
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
  li $v0, 1            
  move $a0, $t3
  syscall

