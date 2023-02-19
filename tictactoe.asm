.data

P1move: .asciiz "~PLAYER 1 MOVE~ \n" #let player 1 know its their move
P2move: .asciiz "~PLAYER 2 MOVE~ \n" #let player 2 know its their move

gameboard: .asciiz "0|1|2\n3|4|5\n6|7|8\n" #gameboard slay but chandy will make better array one
pickmove: .asciiz "where on the board do you want to go? (enter a value 0-8)\n" #pick a move msg
confirm: .asciiz "your move has been recorded\n"

check: .asciiz "check"
msg1: .asciiz "you did it dumb person, aka Player 1"
msg2: .asciiz "you did it dumb person, aka Player 2"

board: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 #current array, named board >:)
empty: .word 0

.text

.globl main #omg main can be EVERYWHERE because it is global

main: #main
 
 ###initalizing most likely
 la $s0, board #setting the starting address of the board to $s0

P1Print:
 li $s3, 1 #player 1

 li $v0, 4
 la $a0, P1move 
 syscall

jal Print_and_Get

P2Print:
  li $s3, 2 #player 2

  li $v0, 4
  la $a0, check 
  syscall

  li $v0, 4
  la $a0, P2move 
  syscall

Print_and_Get:
###printing the prompts for each round
 
  li $v0, 4
  la $a0, gameboard
  syscall

  li $v0, 4
  la $a0, pickmove
  syscall

  ###system call for reading an integer from user
  li $v0, 5 
  syscall

  ###Moving the integer input to another register! because it is temp now not a v value silly
  move $t0, $v0

  ###get to the correct location in the array
  #recall  $s0 is the board array and $s2 is the index and $t0 is the user input
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

  jal H1


P2:
  bne $t3, 0, P2Print
  sw $s3, 0($t4)

  li $v0, 4
  la $a0, confirm 
  syscall
  jal H1
  

H1:

  lw $t6, 0($s0) # $t0 = A[i]
  lw $t7, 4($s0) # $t0 = A[i]
  lw $t8, 8($s0) # $t0 = A[i]
  
  beq $t6, 0, H2
  beq $t7, 0, H2
  beq $t8, 0, H2

  bne $t6, $t7, H2
  bne $t6, $t8, H2
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

H2:
  lw $t6, 12($s0) # $t0 = A[i]
  lw $t7, 16($s0) # $t0 = A[i]
  lw $t8, 20($s0) # $t0 = A[i]

  beq $t6, 0, H3
  beq $t7, 0, H3
  beq $t8, 0, H3

  bne $t6, $t7, H3
  bne $t6, $t8, H3
  beq $s3, 1, P1Win
  beq $s3, 2, P2Win

H3:
  lw $t6, 24($s0) # $t0 = A[i]
  lw $t7, 28($s0) # $t0 = A[i]
  lw $t8, 32($s0) # $t0 = A[i]

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

exit:
 li $v0, 10
 syscall