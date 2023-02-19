  .data

P1move: .asciiz "~PLAYER 1 MOVE~ \n" #let player 1 know its their move
P2move: .asciiz "~PLAYER 2 MOVE~ \n" #let player 2 know its their move

pickmove: .asciiz "where on the board do you want to go? (enter a value 0-8)\n" #pick a move msg
confirm: .asciiz "your move has been recorded\n"

P1Wins: .asciiz "you did it dumb slut, aka Player 1"
P2Wins: .asciiz "you did it dumb slut, aka Player 2"

boardArr: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
empty: .word 0

  .text
  .globl main 

main:
  ###initalizing most likely
  la $s0, boardArr #setting the starting address of the board to $s0
  li $s2, 0
  li $s4, 0

  P1Print:
    li $s3, 1 #player 1

  li $v0, 4
  la $a0, P1move 
  syscall

  jal Print_and_Get

  P2Print:
  li $s3, 2 #player 2

  li $v0, 4
  la $a0, P2move 
  syscall

  Print_and_Get:
    # printing the board
    jal printBoard

    # prompt for getting move
    li $v0, 4
    la $a0, pickmove
    syscall

    # read user input
    li $v0, 5
    syscall
    # move the integer input to another register
    move $t0, $v0

    # get to the correct location in the array
    # recall  $s0 is the board array and $s2 is the index and $t0 is the user input
    mul $t1, $t0, 4
    add $t4, $s0, $t1# add $s1, $t1, $s0 # $t4 = new index + $s0 -> we are adding the index to the location of our array (to get where we want the data teehee)
    lw $t3, 0($t4) #0($t1) # $t3 = A[i], so now we have $t3 is our value in the array (time to test if it is zero or another number)

    bne $s3, 1, P2 # which player is it?

  P1: 
    bne $t3, 0, P1Print # not empty
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

  # Terminate program
  li $v0, 10
  syscall


### FXN: PRINT THE BOARD
printBoard:
  li $t0, 0 # holds index of current element
  li $t1, 0 # counter of elements processed

  # FIRST ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # SECOND ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # THIRD ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  li $v0, 11
  li $a0, 10 # newline
  syscall

  # FOURTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # FIFTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # SIXTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  li $v0, 11
  li $a0, 10 # newline
  syscall

  # SEVENTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # EIGHTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # NINTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t0)
  syscall

  # increment index by 4 bytes
  sll $t3, $t1, 2
  add $t0, $t0, $t3 # update current address

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  li $v0, 11
  li $a0, 10 # newline
  syscall

  jal $ra