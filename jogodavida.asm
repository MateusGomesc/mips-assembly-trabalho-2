#################################################################################
# Autor:        Leonardo Pereira da Silva
# Data:         06/03/2026
# Descrição:    Implementa o Tabuleiro do "Jogo da Vida" e suas Iterações
#               a partir das um estado inicial predefinido
#################################################################################

.data       # 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21  matriz 21x21
matrixA:.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #0     # Tabuleiro Inicial (matriz interna 20x20)
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #1
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #2     # Fileiras na borda (indices 0 e 21) são
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #3     # consideradas fora do tabuleiro
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #3
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #4
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #5     
        .byte 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #6
        .byte 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #7     
        .byte 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #8
        .byte 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #9
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #10
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #11
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #12
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #13
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #14
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #15
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #16
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #17
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #18
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #19
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #20
        .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 #21
matrixB:.space 482                        # Matriz para receber próxima geração
N_Cols: .word 22

viva:   .asciiz "|#|"			 # |#| representa uma célula viva
morta:  .asciiz "| |"			 # | | representa uma célula viva
nl:     .asciiz "\n"

msg0:    .asciiz "############################################################\n#             - Jogo da Vida (Game of Life) -              #\n############################################################\n"
msg1:   .asciiz "Tabuleiro Inicial:\n"
msg2:   .asciiz "\nEntre com o número de iterações desejadas: "
msg3:   .asciiz "\nPróxima geração:\n"


.text
.globl main
main:

# ponteiro da matriz atual
la $s0, matrixA

# IMPRIME TITULO
li $v0,4
la $a0,msg0
syscall

li $v0,4
la $a0,msg1
syscall

# IMPRIME TABULEIRO INICIAL
move $a0, $s0
jal ImprimeTabuleiro

# LEITURA DO NÚMERO DE ITERAÇÕES
li $v0,4
la $a0,msg2
syscall

li $v0,5
syscall

move $s7,$v0        # contador de iterações

# LOOP DE ITERAÇÕES
LoopIteracoes:

beq $s7,$zero,Fim

jal AtualizaTabuleiro

li $v0,4
la $a0,msg3              # Imprime "Próxima geração"
syscall

move $a0, $s0
jal ImprimeTabuleiro

addi $s7,$s7,-1

j LoopIteracoes


Fim:

li $v0,10
syscall

################################################################
# Função        ImprimeTabuleiro
# Descrição:    Percorre a matriz interna e Imprime o tabuleiro
# Entradas:     $a0: endereço base da matriz;  (lê NCols)
# Saída:        N/A (Imprime na tela)
# Reg. Temp.:   $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8
################################################################
ImprimeTabuleiro:
li $t2, 1                # j = 1 (contador de linhas internas)
lw $t4, N_Cols           # $t4 = número de colunas da matriz
move $t7, $a0            # $t7 = endereço base da matriz

# LOOP EXTERNO – percorre as linhas da matriz
LoopExt:
slti $t3, $t2, 21         # verifica se j < 6
beq $t3, $zero, SairLoopExt

li $t0, 1                # i = 1 (contador de colunas internas)

# LOOP INTERNO – percorre as colunas da linha
LoopInt:

slti $t1, $t0, 21         # verifica se i < 6
beq $t1, $zero, SairLoopInt

# ------------------------------------------------
# Calcula endereço da célula (i,j)
# offset = (j * N_Cols) + i
# endereço = matrix + offset
mul $t5, $t2, $t4        # $t5 = j * N_ColsS
add $t5, $t5, $t0        # $t5 = offset += i
add $t8, $t7, $t5        # $t8 = endereço da célula (i,j)

# Lê valor da célula
lb $t6, 0($t8)           # $t6 = estado da célula


# Imprime célula
bne $t6, $zero, PrintViva   # se célula ≠ 0, então celula viva

# Célula morta
PrintMorta:
li $v0, 4
la $a0, morta               # imprime "| |"
syscall
j FimPrint

# Célula viva
PrintViva:
li $v0, 4
la $a0, viva                # imprime "|#|"
syscall

# Próxima célula da linha
FimPrint:

addi $t0, $t0, 1            # i++
j LoopInt

# Fim da linha
SairLoopInt:

li $v0, 4
la $a0, nl                  # imprime newline
syscall

addi $t2, $t2, 1            # j++
j LoopExt

# Fim da impressão do tabuleiro
SairLoopExt:

jr $ra

################################################################
# Função        AtualizaTabuleiro
# Descrição:    Calcula a próxima geração do Tabuleiro
# Entradas:     N/A. (lê MatrizA, MatrizB e NCols)
# Saída:        N/A. (matrixA é atualizada)
# Reg. Temp.:   $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9
################################################################
AtualizaTabuleiro:
# $s0 -> matriz atual
# $s1 -> matriz destino

lw $s2, N_Cols              # número de colunas

# ------------------------------------------------
# Define matriz destino
la $t0, matrixA
beq $s0,$t0,DestinoB

la $s1, matrixA
j DestinoOk

DestinoB:
la $s1, matrixB

DestinoOk:

# início da área interna da matriz destino
move $s4,$s1       # guarda Base da matriz destino
addi $s1,$s1,23     # posiciona na primeira célula interna

# ------------------------------------------------
# Início da varredura da matriz
addi $s3,$s0,23          # primeira célula interna da matriz atual

li $t4,1                # j = 1

# LOOP EXTERNO (linhas)
LoopLinha:

slti $t5,$t4,21
beq $t5,$zero,FimAtualiza

li $t0,1                    # i = 1
move $t1,$s3                # endereço primeira célula

# LOOP INTERNO (colunas)
LoopColuna:

slti $t5,$t0,21
beq $t5,$zero,ProxLinha

move $t7,$t1                # endereço da célula atual

# ------------------------------------------------
# Conta vizinhos vivos (Lê em $t8 e soma em $t9)
li $t9,0

lb $t8,1($t7)
add $t9,$t9,$t8

lb $t8,-1($t7)
add $t9,$t9,$t8

sub $t2,$t7,$s2            # (linha de cima) $t2 = end cel atual - NCols

lb $t8,0($t2)
add $t9,$t9,$t8

lb $t8,1($t2)
add $t9,$t9,$t8

lb $t8,-1($t2)
add $t9,$t9,$t8

add $t2,$t7,$s2            # (linha de baixo) $t2 = end cel atual + NCols

lb $t8,0($t2)
add $t9,$t9,$t8

lb $t8,1($t2)
add $t9,$t9,$t8

lb $t8,-1($t2)
add $t9,$t9,$t8


# ------------------------------------------------
# Regras do Jogo da Vida
lb $t3,0($t7)

beq $t3,$zero,CelulaMorta             # Se 0, celular morta

li $t6,2
beq $t9,$t6,VivaProx                  # Se nro de vizinhas = 2, permanece viva

li $t6,3
beq $t9,$t6,VivaProx                  # Se nro de vizinhas = 3, permanece viva

j Morre                               # Senão, morre

CelulaMorta:                          # Se estiver morta

li $t6,3
beq $t9,$t6,Nasce                     # Se nro de visinhas = 3, nasce

j Continua

Nasce:
li $t8,1
sb $t8,0($s1)
j Continua

VivaProx:
li $t8,1
sb $t8,0($s1)
j Continua

Morre:
sb $zero,0($s1)


# ------------------------------------------------
# Próxima célula
Continua:

addi $t1,$t1,1
addi $s1,$s1,1
addi $t0,$t0,1

j LoopColuna


# ------------------------------------------------
# Próxima linha
ProxLinha:

add $s3,$s3,$s2        # próxima linha da matriz origem
addi $s1,$s1,2         # pula as duas bordas da matriz destino
addi $t4,$t4,1

j LoopLinha

# ------------------------------------------------
# Troca matrizes
FimAtualiza:

move $t0,$s0
move $s0,$s4
move $s1,$t0

jr $ra
