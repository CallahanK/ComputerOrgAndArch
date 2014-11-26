#Computer Org and Arch
#Assignment 2
#Kevin Callahan



        .data
        .align 2
array: .space 15*4
arraySort: .space 15*4

arrayMax: .word 14
arrayMin: .word 9

str1: .asciiz "Begin entering array values, \nterminate array with a zero character \n"
str2: .asciiz "You must enter at least 10 values before completing array input \n"
str3: .asciiz ", " 
str4: .asciiz "\n\nThe largest integer in the array is " 
str5: .asciiz "\n\nThe average value of the array is " 
str6: .asciiz "\n\nThe number of positive values in the array is " 
str7: .asciiz "\n\nThe number of negative values in the array is " 
str8: .asciiz "\n\nThe sorted array is "
str9: .asciiz "\n\nThe size of the array is "  
str10: .asciiz "\n\nThe entered array is "  

newline: .asciiz "\n"

        .text
        .globl main
main:

    la $t0, array      #array address
    li $t1, 0          #array index
    lw $t2, arrayMin   #array min size
    lw $t3, arrayMax   #array max size
    la $t9, arraySort  #fills array to be later sorted



    li $v0, 4
    la $a0, str1
    syscall 

    j BuildArray



MinArraySizeCheck:
    blt $t2,$t1, ExitBuiltArray     #Exit array if min number of array values entered
    li $v0, 4
    la $a0, str2
    syscall                         #Prints error message if min number of array not entered, allows user to continue entering




BuildArray:    
    blt $t3,$t1, ExitBuiltArray     #more than 15 values
    
    li $v0, 5
    syscall

    beq $v0,$0, MinArraySizeCheck   #Check for exit if 0

    sw $v0, 0($t0)
    addi $t0,$t0,4

    sw $v0, 0($t9)
    addi $t9,$t9,4

    addi $t1,$t1,1

    j BuildArray


ExitBuiltArray:

    la $t0, array      #array address
    move $s1,$t1       #Store array lenth


    li $v0, 4
    la $a0, str10
    syscall

PrintArray:
    subu $t1,$t1,1
    li $v0,1
    lw $a0, 0($t0)
    syscall
  
    addi $t0,$t0,4
    beq $t1,$0,ExitPrint

    li $v0, 4
    la $a0, str3
    syscall

    j PrintArray

ExitPrint:

#Print array size
    li $v0, 4
    la $a0, str9
    syscall 

    li $v0,1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, str4
    syscall

    la $t0, array      #array address
    lw $t4,array
    move $t1,$s1
    addi $t1,$t1,1

LargestInteger:
    subu $t1,$t1,1
    beq $t1,$0,ExitLargest

    lw $t5,0($t0)
    slt $s2,$t4,$t5
    addi $t0,$t0,4
    beq $s2,$0,LargestInteger

    move $t4,$t5
    #bne $s2,$0,LargestInteger
    j LargestInteger

ExitLargest:

    li $v0,1
    move $a0,$t4
    syscall

    la $t0, array      #array address
    move $t1,$s1

CalculateTotal:
    subu $t1,$t1,1
    lw $t4,0($t0) 

    add $s3,$s3,$t4

    addi $t0,$t0,4

    bne $t1,$0,CalculateTotal
#Calculate average
    div $s3,$s3,$s1

    li $v0, 4
    la $a0, str5
    syscall

    li $v0,1
    move $a0,$s3
    syscall

#Count positive numbers
    la $t0, array      #array address
    move $t1,$s1
    move $t5,$0

CountPositives:
    beq $t1,$0,EndCountPositives
    subu $t1,$t1,1
    lw $t4,0($t0) 
    addi $t0,$t0,4

    slt $t4,$t4,$0
    bne $t4,$0,CountPositives

    addi $t5,$t5,1     #increment number of positives
    bne $t1,$0,CountPositives

EndCountPositives:

    li $v0, 4
    la $a0, str6
    syscall

    li $v0,1
    move $a0,$t5
    syscall




#Count negatives
    la $t0, array      #array address
    move $t1,$s1
    move $t5,$0

CountNegatives:
    beq $t1,$0,EndCountNegatives
    subu $t1,$t1,1
    lw $t4,0($t0) 
    addi $t0,$t0,4

    slt $t4,$0,$t4
    bne $t4,$0,CountNegatives

    addi $t5,$t5,1     #increment number of negatives
    bne $t1,$0,CountNegatives

EndCountNegatives:

    li $v0, 4
    la $a0, str7
    syscall

    li $v0,1
    move $a0,$t5
    syscall




    la $t0, arraySort      #array address
    move $t2,$0       #Store array length

#for length of array
for:
    
    addi $t0,$t0,4
    addi $t2,$t2,1

    beq $s1,$t2,forExit

    lw $t4,0($t0)
    move $t1,$t0
    move $t3,$t2

#while j > 0 and array j > x
while:    
    beq $t3,$0,for

    subu $t3,$t3,1
    subu $t1,$t1,4

    lw $t5,0($t1)

    blt $t4,$t5,whileShift

    j for
#Shift if x<x-1
whileShift:
    sw $t5,4($t1)

    sw $t4,0($t1)

    j while

forExit:


    li $v0, 4
    la $a0, str8
    syscall

    la $t0, arraySort      #array address
    move $t1,$s1       #Store array lenth

PrintArraySort:
    subu $t1,$t1,1
    li $v0,1
    lw $a0, 0($t0)
    syscall
  
    addi $t0,$t0,4
    beq $t1,$0,ExitPrintSort

    li $v0, 4
    la $a0, str3
    syscall

    j PrintArraySort

ExitPrintSort:




    jr $ra
    .end main