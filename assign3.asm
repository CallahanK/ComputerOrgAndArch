#Computer Org and Arch
#Assignment 3
#Kevin Callahan

.data
        .align 2

row: .word 4
col: .word 4
matrixLength: .word (4*4)

matrixA: .space (4*4)*4
matrixB: .space (4*4)*4
matrixC: .space (4*4)*4

strA: .asciiz "matrix A \n"
strB: .asciiz "matrix B \n"
strC: .asciiz "difference matrix \n"

    .text
    .globl main
main:

#Read for matrix A
    la $a1, matrixA
    lw $a2, matrixLength
    la $a3, strA

    sw $ra, 0($sp)
    jal READM

#Read for matrix B
    la $a1, matrixB
    lw $a2, matrixLength
    la $a3, strB

    jal READM

#Print for matrix A
    la $a1, matrixA
    lw $a2, row
    lw $a3, col
    la $s1, strA

    jal PRINTM

#Print for matrix B
    la $a1, matrixB
    lw $a2, row
    lw $a3, col
    la $s1, strB

    jal PRINTM

#Perform Subtraction
    la $a1, matrixC
    la $a2, matrixA 
    la $a3, matrixB
    lw $s1, matrixLength

    jal SUBM

#Print for matrix C - difference matrix
    la $a1, matrixC
    lw $a2, row
    lw $a3, col
    la $s1, strC

    jal PRINTM


    lw $ra,0($sp)
    jr $ra
    .end main




#$a1 = address of matrix to be read
#$a2 = matrixLength
#$a3 = name of matrix
READM:    
    
    .data
    .align 2

str1Read: .asciiz  "\nBegin input for "
str2Read: .asciiz "\nInput entry complete. \n"


    .text

    li $v0, 4
    la $a0, str1Read
    syscall

    li $v0, 4
    move $a0, $a3
    syscall


loopRead:

    li $v0, 5
    syscall

    sw $v0, 0($a1)
    addi $a1,$a1,4

    addi $a2,$a2,-1

    blt $0,$a2, loopRead

    li $v0, 4
    la $a0, str2Read
    syscall

    jr $ra
    .end READM




#$a1 = address of matrix to be printed
#$a2 = row
#$a3 = col
#$s1 = name of matrix
PRINTM:    
    
    .data
    .align 2

str1Print: .asciiz "\nPrinting "
str2Print: .asciiz "\nPrint complete. \n"
comma:     .asciiz " , "
newline:   .ascii "\n"


    .text

    li $v0, 4
    la $a0, str1Print
    syscall

    li $v0, 4
    move $a0, $s1
    syscall    

# Initialize matrix address, row count
        move $t3,$a1
        
        li $t0,0 #initialize row count
        
 outer:
        la $a0,newline #start new line
        li $v0,4
        syscall

        addi $t0,$t0,1 # next row
        bgt  $t0,$a2,Done # Finished printing, return now
        li $t2,0 # number count printed in a row,initialize
 inner:         
        addi $t2,$t2,1
        lw $a0,0($t3)
        li $v0,1
        syscall
        addi $t3,$t3,4
        beq $t2,$a3,outer # row complete,no comma,next line 
        la $a0,comma
        li $v0,4
        syscall
            j inner # go to print next number in same line

 Done:

    li $v0, 4
    la $a0, str2Print
    syscall

    jr $ra
    .end PRINTM


#$a1 = difference matrix
#$a2 = minuend matrix  
#$a3 = subtrahend matrix
#$s1 = matrixLength
SUBM:    


    .data
    .align 2

str1Sub: .asciiz "\nSubtraction complete. \n"

    .text

loopSub:

    lw $t0,0($a2)
    lw $t1,0($a3)

    sub $t0,$t0,$t1

    sw $t0, 0($a1)

    addi $a1,$a1,4
    addi $a2,$a2,4
    addi $a3,$a3,4

    addi $s1,$s1,-1

    blt $0,$s1, loopSub

    li $v0, 4
    la $a0, str1Sub
    syscall

    jr $ra
    .end SUBM
