.data
   prompt:   .asciiz "Numero de discos? "
   msg_move: .asciiz "Move disco do pino "
   msg_para: .asciiz " para o pino "
   newline:  .asciiz "\n"

.text 
.globl main

main:
    # 1. Exibir pergunta
    li $v0, 4
    la $a0, prompt 
    syscall 
    
    # 2. Ler n
    li $v0, 5
    syscall 
    move $a0, $v0     
    
    # 3. Configurar pinos iniciais
    li $a1, 'A'        # Origem
    li $a2, 'B'        # Auxiliar
    li $a3, 'C'        # Destino
    
    jal hanoi
    
    # Finalizar programa
    li $v0, 10 
    syscall 

hanoi:
    # Prólogo: Salvar contexto na pilha
    addi $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s0, 12($sp)
    sw   $s1, 8($sp)
    sw   $s2, 4($sp)
    sw   $s3, 0($sp)

    move $s0, $a0    
    move $s1, $a1   
    move $s2, $a2 
    move $s3, $a3    

    # Caso Base: se n == 1, movemos direto
    li $t0, 1
    beq $s0, $t0, mover_um_disco

    # Passo 1: hanoi(n-1, origem, destino, auxiliar)
    addi $a0, $s0, -1
    move $a1, $s1  
    move $a2, $s3    
    move $a3, $s2    
    jal hanoi

    #Passo 2: Mover o disco atual
    move $a1, $s1
    move $a3, $s3
    jal imprimir_movimento

    #Passo 3: hanoi(n-1, auxiliar, origem, destino)
    addi $a0, $s0, -1
    move $a1, $s2    
    move $a2, $s1   
    move $a3, $s3    
    jal hanoi

    j fim_hanoi

mover_um_disco:
    jal imprimir_movimento

fim_hanoi:

    # Epílogo: Restaurar pilha
    lw   $ra, 16($sp)
    lw   $s0, 12($sp)
    lw   $s1, 8($sp)
    lw   $s2, 4($sp)
    lw   $s3, 0($sp)
    addi $sp, $sp, 20
    jr   $ra

imprimir_movimento:

    # Salva o $a0 original pois vamos usar syscalls
    move $t1, $a0
    
    li $v0, 4
    la $a0, msg_move
    syscall

    li $v0, 11
    move $a0, $a1    # Imprime caractere da Origem
    syscall

    li $v0, 4
    la $a0, msg_para
    syscall

    li $v0, 11
    move $a0, $a3    # Imprime caractere do Destino
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    
    jr $ra
