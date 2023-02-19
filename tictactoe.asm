.data

P1move: .asciiz "~PLAYER 1 MOVE~ \n" #let player 1 know its their move
P2move: .asciiz "~PLAYER 2 MOVE~ \n" #let player 2 know its their move

pickmove: .asciiz "where on the board do you want to go? (enter a value 0-8)\n" #pick a move msg
confirm: .asciiz "your move has been recorded\n"

check: .asciiz "check"
msg1: .asciiz "you did it dumb person, aka Player 1"
msg2: .asciiz "you did it dumb person, aka Player 2"

boardArr: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # current board array
empty: .word 0

.text

.globl main #omg main can be EVERYWHERE because it is global

main:
  la $s0, boardArr # setting the starting address of the boardArr to $s0

### FXN: Display it is P1's move
P1Print:
 li $s3, 1 

 li $v0, 4
 la $a0, P1move 
 syscall

### Branch to print and get
jal Print_and_Get

### FXN: Display it is P1's move
P2Print:
  li $s3, 2 #player 2

  li $v0, 4
  la $a0, check 
  syscall

  li $v0, 4
  la $a0, P2move 
  syscall

### FXN: Printing the prompts for each round and getting user input
Print_and_Get:
  jal printBoard

  li $v0, 4
  la $a0, pickmove
  syscall

  # get user input
  li $v0, 5 
  syscall
  # moving the user input to temp reg
  move $t0, $v0

  # get to the correct location in the array
    # $t0: user input
    # $s0: boardArray
    #################
    # $t3: loads what value is in the position that user chose
      # to be used for checking if it is a valid position
  mul $t1, $t0, 4
  add $t4, $s0, $t1 # add $s1, $t1, $s0 # $t4 = new index + $s0 -> we are adding the index to the location of our array (to get where we want the data teehee)
  lw $t3, 0($t4) # 0($t1) # $t3 = A[i], so now we have $t3 is our value in the array (time to test if it is zero or another number)

bne $s3, 1, P2 # if it is player 1 -> go to P2

P1: 
  bne $t3, 0, P1Print # not empty position -> reprompt P1
  sw $s3, 0($t4) # empty -> store player in position

  li $v0, 4
  la $a0, confirm 
  syscall

  jal H1


P2:
  bne $t3, 0, P2Print # not empty position -> reprompt P2
  sw $s3, 0($t4)

  li $v0, 4
  la $a0, confirm 
  syscall
  jal H1

H1:
  lw $t6, 0($s0) 
  lw $t7, 4($s0) 
  lw $t8, 8($s0)
  
  beq $t6, 0, H2
  beq $t7, 0, H2
  beq $t8, 0, H2

  bne $t6, $t7, H2
  bne $t6, $t8, H2
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

H2:
  lw $t6, 12($s0)
  lw $t7, 16($s0)
  lw $t8, 20($s0)

  beq $t6, 0, H3
  beq $t7, 0, H3
  beq $t8, 0, H3

  bne $t6, $t7, H3
  bne $t6, $t8, H3
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

H3:
  lw $t6, 24($s0)
  lw $t7, 28($s0)
  lw $t8, 32($s0)

  beq $t6, 0, freak
  beq $t7, 0, freak
  beq $t8, 0, freak

  bne $t6, $t7, freak
  bne $t6, $t8, freak
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

freak:
  li $v0, 4
  la $a0, check 
  syscall

  li $v0, 1
  move $a0, $s3 
  syscall

  beq $s3, 1, P2Print
  beq $s3, 2, P1Print

P1Win:
  li $v0, 4
  la $a0, msg1 
  syscall

  jal exit

P2Win:
  li $v0, 4
  la $a0, msg2 
  syscall

  jal exit

### FXN: PRINT THE BOARD
printBoard:
  li $t1, 0 # index of current element

  # FIRST ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4 

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # SECOND ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4  

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # THIRD ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  li $v0, 11
  li $a0, 10 # newline
  syscall

  # FOURTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4  

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # FIFTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # SIXTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  li $v0, 11
  li $a0, 10 # newline
  syscall

  # SEVENTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4  

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # EIGHTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4  

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  # NINTH ELEMENT
  li $v0, 1
  lw $a0, boardArr($t1)
  syscall

  # increment index by 4 bytes
  addi $t1, $t1, 4 

  # separator
  li $v0, 11 # syscall number to print a character
  li $a0, 0x7C # '|'
  syscall

  li $v0, 11
  li $a0, 10 # newline
  syscall

  jal $ra


exit:
 li $v0, 10
 syscall