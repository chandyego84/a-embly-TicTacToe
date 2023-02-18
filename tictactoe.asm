.data

P1move: .asciiz "~PLAYER 1 MOVE~ \n" #let player 1 know its their move
P2move: .asciiz "~PLAYER 2 MOVE~ \n" #let player 2 know its their move

gameboard: .asciiz "0|1|2\n3|4|5\n6|7|8\n" #gameboard slay but chandy will make better array one
pickmove: .asciiz "where on the board do you want to go? (enter a value 0-8)\n" #pick a move msg

board: .word 9, 1, 2, 3, 4, 5, 6, 7, 8 #current array, named board >:)

.text

.globl main #omg main can be EVERYWHERE because it is global

main: #main
 
 ###initalizing most likely
 la $s0, board #setting the starting address of the board to $s0
 li $s2, 0 #index


P1Print_and_Get:
###printing the prompts for each round
  li $v0, 4
  la $a0, P1move 
  syscall

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
 

  ###syscall for printing int- commented out but good to know i suppose
  #li $v0, 1            
  #move $a0, $t0
  #syscall

###get to the correct location in the array
#recall  $s0 is the board array and $s2 is the index and $t0 is the user input
  sllv $t1, $s2, $t0 # left shift the index by the user input once, and then store it in a temporary value
  sllv $t1, $s2, $t0 #again
  add $t1, $t1, $s0 # $t1 = new index + $s0 -> we are adding the index to the location of our array (to get where we want the data teehee)
  lw $t3, 0($s0)#0($t1) # $t3 = A[i], so now we have $t3 is our value in the array (time to test if it is zero or another number)

 li $v0, 1            
 move $a0, $t3
 syscall

 #exit
 li $v0, 10
 syscall