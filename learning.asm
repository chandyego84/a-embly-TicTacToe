    .data

prompt1: .asciiz "Enter the first number: "
prompt2: .asciiz "Enter the second number: "
menu: .asciiz "Enter the number associated with the operation: 1 => add, 2 => subtract"
resultText: .asciiz "Your final result is: "

    .text
    .globl main

main:
    ### Following code is to pre-load integer values
    ### representing the various instructions into regs for storage
    li $t3, 1 # load immediate value of 1 into $t3
    li $t4, 2 # load immediate value of 2 into $t4

    ### Print out the instructions that require user to input
    ### two numbers that they would like to perform operations on
    li $v0, 4 # command for printing a string
    la $a0, prompt1 # loading string to print into the arg to enable printing
    syscall # execute the command

    ### Following code is for reading the first number provided by the user
    li $v0, 5 # command for reading an integer
    syscall # execute the command
    move $t0, $v0 # moving number read from user input into reg $t0
    
    ### Asking the user to provide the second number
    li $v0, 4 # command for printing a string
    la $a0, prompt2 # load string into arg to enable printing
    syscall

    ### Reading the second number to be provided to the user
    li $v0, 5 # command to read the number provided by user
    syscall
    move $t1, $v0 # move number read from user input into $t1

    ### PRINTING OUT COMMANDS USER CAN PERFORM ON THE NUMBERS
    li $v0, 4 # command for printing a string
    la $a0, menu # loading string into the arg to enable printing
    syscall

    ### Read the number provided by the user
    li $v0, 5 # read an integer
    syscall
    move $t2, $v0 # move int provided into $t2

    ### CREATE CONTROL STRUCTURES TO DETERMINE WHICH INSTRUCTIONS TO BE EXECUTED
    ### BASED ON COMMAND ISSUED BY THE USER
    ### DETERMINE WHAT SHOULD TAKE PLACE DEPENDING ON USER INPUT
    beq $t2, $t3, addProcess # branch to 'addProcess' if $t2 == $t3
    beq $t2, $t4, subtractProcess # branch to 'subtractProcess' if $t2 == $t4

    ### ADDING THE TWO NUMBERS PROVIDED
    addProcess:
        add $t6, $t0, $t1 # adds values in $t0 and $t1 --> reg $t6

        ### print results of computations above
        li $v0, 4 # printing a string
        la $a0, resultText # loads string to print into arg $a0 for printing
        syscall

        # prints out result of addition computation
        li $v0, 1
        la $a0, ($t6)
        syscall

        li $v0, 10 # terminate the program
    
    ### SUBTRACT THE TWO NUMBERS PROVIDED
    subtractProcess:
        sub $t6, $t0, $t1 # subtracts values stored in t0 and t1 -> reg t6
        li $v0, 4 # printing a string command
        la $a0, resultText # loads string to print into arg $a0 for printing
        syscall

        ### prints outs result of subtraction computation
        li $v0, 1
        la $a0, ($t6)
        syscall

        li $v0, 10 # terminate the program