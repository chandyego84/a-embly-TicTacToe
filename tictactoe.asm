.data

P1move: .asciiz "~PLAYER 1 MOVE~ \n" #let player 1 know its their move
P2move: .asciiz "~PLAYER 2 MOVE~ \n" #let player 2 know its their move

pickmove: .asciiz "Pick a position on the board to play (enter a value 0-8)\n"
confirm: .asciiz "Your move has been recorded.\n"

check: .asciiz " debuggingCheck "
msg1: .asciiz "You did it dumb person, aka Player 1!"
msg2: .asciiz "You did it dumb person, aka Player 2!"
msg3: .asciiz "Nobody won!"

boardArr: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # current board array
empty: .word 0

.text
.globl main 

main:
  la $s0, boardArr # setting the starting address of the boardArr to $s0
  li $t9, 0

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

  # debug
  #li $v0, 4
  #la $a0, check 
  #syscall

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

  addi $t9, $t9, 1

  li $v0, 4
  la $a0, confirm 
  syscall

  beq $t9, 9, NoWin # draw

  jal H1


P2:
  bne $t3, 0, P2Print # not empty position -> reprompt P2
  sw $s3, 0($t4)

  addi $t9, $t9, 1

  li $v0, 4
  la $a0, confirm 
  syscall

  beq $t9, 9, NoWin # draw

  jal H1

### FXN: Check first horizontal for win
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

### FXN: Check second horizontal for win
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

### FXN: Check third horizontal for win
H3:
  lw $t6, 24($s0)
  lw $t7, 28($s0)
  lw $t8, 32($s0)

  beq $t6, 0, V1
  beq $t7, 0, V1
  beq $t8, 0, V1

  bne $t6, $t7, V1
  bne $t6, $t8, V1
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

V1:
  lw $t6, 0($s0) 
  lw $t7, 12($s0) 
  lw $t8, 24($s0)
  
  beq $t6, 0, V2
  beq $t7, 0, V2
  beq $t8, 0, V2

  bne $t6, $t7, V2
  bne $t6, $t8, V2
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

V2:
  lw $t6, 4($s0) 
  lw $t7, 16($s0) 
  lw $t8, 28($s0)
  
  beq $t6, 0, V3
  beq $t7, 0, V3
  beq $t8, 0, V3

  bne $t6, $t7, V3
  bne $t6, $t8, V3
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

V3:
  lw $t6, 8($s0) 
  lw $t7, 20($s0) 
  lw $t8, 32($s0)
  
  beq $t6, 0, D1
  beq $t7, 0, D1
  beq $t8, 0, D1

  bne $t6, $t7, D1
  bne $t6, $t8, D1
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

D1:
  lw $t6, 0($s0) 
  lw $t7, 16($s0) 
  lw $t8, 32($s0)
  
  beq $t6, 0, D2
  beq $t7, 0, D2
  beq $t8, 0, D2

  bne $t6, $t7, D2
  bne $t6, $t8, D2
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

D2:
  lw $t6, 8($s0) 
  lw $t7, 16($s0) 
  lw $t8, 24($s0)
  
  beq $t6, 0, freak
  beq $t7, 0, freak
  beq $t8, 0, freak

  bne $t6, $t7, freak
  bne $t6, $t8, freak
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

### FXN: When no win has occurred, switch back to other player for reprompting
freak:
  # debugging
  #li $v0, 4
  #la $a0, check 
  #syscall
  #li $v0, 1
  #move $a0, $s3 
  #syscall

  beq $s3, 1, P2Print # if player1 turn -> prompt player2 (switch players)
  beq $s3, 2, P1Print # if player2 turn -> prompt player1 (switch players)

### FXN: Player 1 won!
P1Win:
  li $v0, 4
  la $a0, msg1 
  syscall

  jal exit

### FXN: Player 2 won!
P2Win:
  li $v0, 4
  la $a0, msg2 
  syscall

  jal exit

NoWin:
  li $v0, 4
  la $a0, msg3 
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