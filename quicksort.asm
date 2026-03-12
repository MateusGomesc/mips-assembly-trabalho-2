```assembly
############################################################
# quicksort.asm
# Autor : Davi Gonçalves Cabeceira
# Data : 12 / 03 / 2026
# Descrição : Implementação do QuickSort em MIPS com função main de teste
############################################################

.data                           # seção de dados do programa

array: .word 7,2,9,1,5,4,3,8    # vetor de teste com 8 inteiros
size:  .word 8                  # tamanho do vetor

space: .asciiz " "              # string usada para imprimir espaço
newline: .asciiz "\n"           # string usada para pular linha

.text                           # seção de código
.globl main                     # declara main como função global

############################################################
# FUNÇÃO PRINCIPAL (MAIN)
############################################################

main:                           # início da função main

    la $a0,array                # $a0 recebe o endereço base do vetor (1º argumento)

    lw $t0,size                 # $t0 recebe o valor armazenado em size (8)

    addi $a1,$zero,0            # $a1 = 0 → índice inicial do vetor (low)

    addi $a2,$t0,-1             # $a2 = size - 1 → índice final do vetor (high)

    jal quicksort               # chama quicksort(array,0,size-1)

############################################################
# Impressão do vetor ordenado
############################################################

    li $t1,0                    # $t1 será usado como índice i → i = 0

print_loop:                     # início do loop de impressão

    lw $t2,size                 # carrega o tamanho do vetor em $t2

    bge $t1,$t2,end_print       # se i >= size termina o loop

    sll $t3,$t1,2               # $t3 = i * 4 (cada inteiro ocupa 4 bytes)

    la $t4,array                # $t4 recebe o endereço base do vetor

    add $t3,$t4,$t3             # $t3 agora contém o endereço de array[i]

    lw $a0,0($t3)               # carrega array[i] para $a0 (argumento do print)

    li $v0,1                    # syscall 1 = imprimir inteiro

    syscall                     # imprime o valor de array[i]

    la $a0,space                # carrega endereço da string " "

    li $v0,4                    # syscall 4 = imprimir string

    syscall                     # imprime espaço entre números

    addi $t1,$t1,1              # i++

    j print_loop                # volta para continuar imprimindo

end_print:                      # rótulo para fim da impressão

    li $v0,10                   # syscall 10 = encerrar programa

    syscall                     # finaliza execução

############################################################
# FUNÇÃO QUICKSORT
# Parâmetros:
# $a0 = endereço do array
# $a1 = low
# $a2 = high
############################################################

quicksort:

    addi $sp,$sp,-24            # reserva 24 bytes na pilha para salvar registradores

    sw $ra,20($sp)              # salva endereço de retorno da função

    sw $s0,16($sp)              # salva registrador s0

    sw $s1,12($sp)              # salva registrador s1

    sw $s2,8($sp)               # salva registrador s2

    sw $s3,4($sp)               # salva registrador s3

    sw $s4,0($sp)               # salva registrador s4

############################################################
# copiar parâmetros da função para registradores salvos
############################################################

    move $s0,$a0                # s0 = endereço base do vetor

    move $s1,$a1                # s1 = low

    move $s2,$a2                # s2 = high

############################################################
# inicializar variáveis i e j
############################################################

    move $s3,$s1                # i = low

    move $s4,$s2                # j = high

############################################################
# calcular pivot = array[(low+high)/2]
############################################################

    add $t0,$s1,$s2             # t0 = low + high

    sra $t0,$t0,1               # divide por 2 → índice do elemento central

    sll $t1,$t0,2               # t1 = índice * 4 (offset em bytes)

    add $t1,$s0,$t1             # t1 = endereço de array[(low+high)/2]

    lw $t2,0($t1)               # t2 = pivot (valor do elemento central)

############################################################
# while (i <= j)
############################################################

while_loop:

    bgt $s3,$s4,while_end       # se i > j sai do loop

############################################################
# while(array[i] < pivot)
############################################################

loop_i:

    sll $t3,$s3,2               # calcula offset de i (i*4)

    add $t3,$s0,$t3             # calcula endereço de array[i]

    lw $t4,0($t3)               # carrega valor de array[i]

    bge $t4,$t2,loop_j          # se array[i] >= pivot sai do loop

    addi $s3,$s3,1              # i++

    j loop_i                    # repete loop

############################################################
# while(array[j] > pivot)
############################################################

loop_j:

    sll $t3,$s4,2               # calcula offset de j (j*4)

    add $t3,$s0,$t3             # calcula endereço de array[j]

    lw $t4,0($t3)               # carrega valor de array[j]

    ble $t4,$t2,check_swap      # se array[j] <= pivot sai do loop

    addi $s4,$s4,-1             # j--

    j loop_j                    # repete loop

############################################################
# realizar troca (swap)
############################################################

check_swap:

    bgt $s3,$s4,while_loop      # se i > j volta ao início do while

    sll $t5,$s3,2               # offset de i

    add $t5,$s0,$t5             # endereço de array[i]

    lw $t6,0($t5)               # t6 = array[i]

    sll $t7,$s4,2               # offset de j

    add $t7,$s0,$t7             # endereço de array[j]

    lw $t8,0($t7)               # t8 = array[j]

    sw $t8,0($t5)               # array[i] = array[j]

    sw $t6,0($t7)               # array[j] = valor antigo de array[i]

    addi $s3,$s3,1              # i++

    addi $s4,$s4,-1             # j--

    j while_loop                # volta ao while principal

############################################################
# fim do while
############################################################

while_end:

############################################################
# chamada recursiva esquerda
############################################################

    bge $s1,$s4,skip_left       # se low >= j não executa recursão

    move $a0,$s0                # argumento 1 = array

    move $a1,$s1                # argumento 2 = low

    move $a2,$s4                # argumento 3 = j

    jal quicksort               # quicksort(array,low,j)

skip_left:

############################################################
# chamada recursiva direita
############################################################

    bge $s3,$s2,skip_right      # se i >= high não executa recursão

    move $a0,$s0                # argumento 1 = array

    move $a1,$s3                # argumento 2 = i

    move $a2,$s2                # argumento 3 = high

    jal quicksort               # quicksort(array,i,high)

skip_right:

############################################################
# restaurar registradores
############################################################

    lw $ra,20($sp)              # restaura endereço de retorno

    lw $s0,16($sp)              # restaura s0

    lw $s1,12($sp)              # restaura s1

    lw $s2,8($sp)               # restaura s2

    lw $s3,4($sp)               # restaura s3

    lw $s4,0($sp)               # restaura s4

    addi $sp,$sp,24             # libera espaço da pilha

    jr $ra                      # retorna para quem chamou a função
```

