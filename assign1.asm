    .text
    .globl main 

main:

    li $v0, 4
    la $a0, input
    syscall           #Print input marker

    li $v0, 5
    syscall           #Read first int
    sw $v0, aray      #store first int

    li $v0, 4
    la $a0, newline
    syscall           #Carriage return

    li $v0, 4
    la $a0, input
    syscall           #Print input marker

    li $v0, 5
    syscall           #Read second int
    sw $v0, aray+4    #Store second int

    li $v0, 4
    la $a0, newline
    syscall           #Carriage return

    li $v0, 4
    la $a0, input
    syscall           #Print input marker

    li $v0, 5         #Read third int
    syscall
    sw $v0, aray+8    #Store third int

    li $v0, 4
    la $a0, newline
    syscall           #Carriage return

    li $v0, 4
    la $a0, input
    syscall           #Print input marker

    li $v0, 5         #Read fourth int
    syscall
    sw $v0, aray+12   #Store fourth int

    li $v0, 4
    la $a0, newline
    syscall           #Carriage return

   

    #Load data into registers
    lw $t0, aray
    lw $t1, aray+4
    lw $t2, aray+8
    lw $t3, aray+12
    lw $t4, dataaray
    lw $t5, dataaray+4

    #Perform calculations 
    div $t1,$t4,$t1
    mul $t2,$t5,$t2
    add $t0,$t0,$t1
    sub $t0,$t0,$t2
    add $t0,$t0,$t3

    #Print result
    li $v0, 4
    la $a0, result
    syscall

    add $a0,$t0,$zero
    li $v0,1
    syscall

    #Store result
    sw $t0, dataresult


    jr $ra

    .data
    .align 2
aray: .space 16
dataaray: .word 15, 10
dataresult: .space 4

result: .asciiz "The result is: "
input: .asciiz "Enter an integer: "
newline: .asciiz "\n"
    .end main