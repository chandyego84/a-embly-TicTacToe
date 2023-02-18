.data

P1move: .asciiz "~PLAYER 1 MOVE~ \n"
P2move: .asciiz "~PLAYER 2 MOVE~ \n"

gameboard: .asciiz "0|1|2\n3|4|5\n6|7|8\n"
                           

pickmove: .asciiz "where on the board do you want to go? \n"

Sz: .word 9
board: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
NL: .asciiz "\n"

.text

.globl main

main:
  jal prompt1

prompt1:
    ### TELL PLAYER1 TURN
    li $v0, 4
    la $a0, P1move
    syscall

    ### SHOW GAMEBOARD
    li $v0, 4
    la $a0, gameboard
    syscall

    ### READ USER INPUT
    li $v0, 4
    la $a0, pickmove
    syscall