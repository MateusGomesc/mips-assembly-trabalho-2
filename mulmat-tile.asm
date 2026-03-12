# Multiplicacao de matrizes de maneira otimizada
# Autor: Mateus Gomes Costa
.data
	n:	.word	64
	b_size:	.word	8
	A:	.space	16384
	B:	.space	16384
	C:	.space	16384
	espaco:	.asciiz	"  "
	breakLine:	.asciiz "\n"
.text
.globl main
main:
	la $t0, A
	la $t1, B
	la $t2, C
	la $t9, n
	lw $s6, 0($t9) # $s6 = n
	la $t9, b_size
	lw $s7, 0($t9) # $s7 = b
	xor $s0, $s0, $s0 # $s0 = i
whilei:
	beq $s0, $s6, endi # $s6 = n, verifica condicao do loop i
	xor $s1, $s1, $s1 # $s1 = j
whilej:
	beq $s1, $s6, endj # Verifica condicao do j
	xor $s2, $s2, $s2 # $s2 = k
whilek:
	beq $s2, $s6, endk # Verifica condicao do k
	add $s3, $0, $s0 # $s3 = i1
whilei1:
	add $t3, $s0, $s7 # i+B
	beq $s3, $t3, endi1 # Verifica condicao do i1
	add $s4, $0, $s1 # $s4 = j1
whilej1:
	add $t3, $s1, $s7 # j+B
	beq $s4, $t3, endj1 # Verifica condicao do j1
	add $s5, $0, $s2 # $s5 = k1
whilek1:
	add $t3, $s2, $s7 # k+B
	beq $s5, $t3, endk1 # Verifica condicao do k1
	# Calculando endereco de A
	mul $t4, $s3, $s6 # i1 * n
	add $t4, $t4, $s5 # (i1 * n) + k1
	sll $t4, $t4, 2
	add $t4, $t0, $t4
	l.s $f4, 0($t4) # $f4 = valor atual de A
	# Calculando endereco de B
	mul $t4, $s5, $s6 # k1 * n
	add $t4, $t4, $s4 # (k1 * n) + j1
	sll $t4, $t4, 2
	add $t4, $t1, $t4
	l.s $f5, 0($t4) # $f5 = valor atual de B
	# Calculando endereco de C
	mul $t4, $s3, $s6 # i1 * n
	add $t4, $t4, $s4 # (i1 * n) + j1
	sll $t4, $t4, 2
	add $t4, $t2, $t4
	l.s $f6, 0($t4) # $f6 = valor atual de C
	# Incrementando no valor de C
	mul.s $f7, $f4, $f5
	add.s $f6, $f6, $f7
	# Guarda valor no endereco de C
	s.s $f6, 0($t4)
	addiu $s5, $s5, 1 # Incrementa 1 no k1
	j whilek1
endk1:
	addiu $s4, $s4, 1 # Incrementa 1 no j1
endj1:
	addiu $s3, $s3, 1 # Incrementa 1 no i1
	j whilei1
endi1:
	add $s2, $s2, $s7 # Incrementa B no k
	j whilek
endk:
	add $s1, $s1, $s7 # Incrementa B no j
	j whilej
endj:
	add $s0, $s0, $s7 # Incrementa B no i
	j whilei
endi:
	li $v0, 10
	syscall
