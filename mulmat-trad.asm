# Multiplicação de matrizes de maneira tradicional
# Autor: Mateus Gomes Costa
.data
	n:	.word	64
	A:	.space	16384
	B:	.space	16384
	C:	.space	16384
	espaco:	.asciiz	"  "
	breakLine:	.asciiz "\n"
.text
.globl main
main:
	# Carregando enderecos base
	la $s3, A
	la $s4, B
	la $s5, C
	la $s6, n
	lw $s6, 0($s6)
	xor $s0, $s0, $s0 # i = $s0
whilei:
	slt $t4, $s0, $s6
	beq $t4, $0, endi # Verifica condicao do loop i
	xor $s1, $s1, $s1 # j = $s1
whilej:
	slt $t5, $s1, $s6
	beq $t5, $0, endj # Verifica condicao do loop j
	mtc1 $0, $f4 # soma = 0.00
	xor $s2, $s2, $s2 # k = $s2
whilek:
	slt $t7, $s2, $s6
	beq $t7, $0, endk # Verifica condicao do loop k
	# Calculando endereco de A
	xor $t8, $t8, $t8
	mul $t8, $s0, $s6
	add $t8, $t8, $s2
	sll $t8, $t8, 2
	add $t8, $s3, $t8
	# Calculando endereco de B
	xor $t9, $t9, $t9
	mul $t9, $s2, $s6
	add $t9, $t9, $s1
	sll $t9, $t9, 2
	add $t9, $s4, $t9
	# Capturando valores
	l.s $f5, 0($t8)
	l.s $f6, 0($t9)
	mul.s $f7, $f5, $f6 # Calcula a multiplicacao
	add.s $f4, $f4, $f7 # Acumula no registrador da soma
	addiu $s2, $s2, 1 # Incrementa no k
	j whilek
endk:
	# Calculando endereco onde vamos colocar a soma
	xor $t6, $t6, $t6
	mul $t6, $s0, $s6
	add $t6, $t6, $s1
	sll $t6, $t6, 2
	add $t6, $s5, $t6
	swc1 $f4, 0($t6)
	addiu $s1, $s1, 1 # Incrementa no j
	j whilej
endj:
	addiu $s0, $s0, 1 # incrementa o i
	j whilei
endi:
	li $v0, 10
	syscall
	
