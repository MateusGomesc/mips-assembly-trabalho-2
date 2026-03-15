.data
    	interseccao:.asciiz "Retângulo feito pela intersecção:"
    	naoIntersecta:.asciiz "Não há intersecção."
    	espaco:.asciiz " "
    	pulaLinha:.asciiz "\n"
	pedeRet1:.asciiz "Digite a coordenadas do primeiro retângulo:"
	pedeRet2:.asciiz "Digite as coordenadas do segundo retângulo:"
	
	# do primeiro ret
	# s0 -> x1     
	# s1 -> y1
	# s2 -> x2
	# s3-> y2
	
	# do segundo ret
	# s4 -> x1     
	# s5 -> y1
	# s6 -> x2
	# s7-> y2
		
.text
.globl main

main:

   	 li $v0, 4
    	la $a0, pedeRet1
   	 syscall
    
    	li $v0, 5           
    	syscall
    	move $s0, $v0      

    	li $v0, 5
    	syscall
    	move $s1, $v0      

    	li $v0, 5
    	syscall
    	move $s2, $v0     

    	li $v0, 5
    	syscall
    	move $s3, $v0
	
	li $v0, 4
    	la $a0, pedeRet2
    	syscall
    
    	li $v0, 5
    	syscall
    	move $s4, $v0       

    	li $v0, 5
    	syscall
    	move $s5, $v0       

    	li $v0, 5
    	syscall
    	move $s6, $v0      

    	li $v0, 5
    	syscall
    	move $s7, $v0      

	# x minimo
    	move $t0, $s0 # to <- x1 do primeiro
    	bge $s0, $s4, yMinimo # se x1 do primeiro ret maior que x1 do segundo
    	move $t0, $s4 # t0 <- x1 do segundo red

yMinimo:
    	move $t1, $s1 
    	ble $s1, $s5, xMax # se y1 do primeiro ret for menor que y1 do segundo
    	move $t1, $s5 # t1 <- y1 do segundo ret

xMax: # menor valor de x
    	move $t2, $s2
    	ble $s2, $s6, yMax # se x2 do primeiro menor que x2 do segundo
    	move $t2, $s6 # t2 <- x2 do segundo ret

yMax:
    	move $t3, $s3
    	bge $s3, $s7, verificaInterseccao # se y2 do primeiro maior que y2 segundo
    	move $t3, $s7 # t3 <- y2 do segundo ret

verificaInterseccao:
    	
	bge $t0, $t2, semInterseccao 
    	ble $t1, $t3, semInterseccao 
    	li $v0, 4
    	la $a0, interseccao
    	syscall

    	li $v0, 1
    	move $a0, $t0
    	syscall
    
    	li $v0, 4
    	la $a0, espaco
    	syscall

    	li $v0, 1
    	move $a0, $t1
    	syscall
    
    	li $v0, 4
    	la $a0, espaco
    	syscall

    	li $v0, 1
    	move $a0, $t2
    	syscall
    
    	li $v0, 4
    	la $a0, espaco
    	syscall

    	li $v0, 1
    	move $a0, $t3
    	syscall
    
    	li $v0, 4
    	la $a0, pulaLinha
    	syscall
    	j exit

semInterseccao:
    	li $v0, 4
    	la $a0, naoIntersecta
    	syscall

exit:
    	li $v0, 10
    	syscall
