#Declaramos macros
        .eqv nodo_ant    0
        .eqv nodo_sig    4
        .eqv nodo_val    8
        .eqv nodo_tamano 12
.data 
        nodo: .word 0
.text
loop_main:
        li $t0, 1
        lw $a0, nodo
        beq $v0, $t0, nuevoNodo

nuevoNodo:#en $a0 recibimos la direccion de un nodo
        move $t0, $a0
        li $a0, 12
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal malloc 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        move $a0, $v0 #cargamos en $a0 la direccion del nodo
        beq $t0, $zero, primerNodo

  
primerNodo: 
        
        sw $a0, 0($a0)
        sw $a0, 4($a0)                   #hacemos que el nodo apunte a si mismo
       
        sw $a0, nodo($0)
        
        
        li $a0, 50                      #pedimos 50 de espacio para el string

        addi $sp, $sp, -4 
        sw $ra, 0($sp)
        jal malloc                      #salto a malloc
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        sw $v0, nodo+8($0)                  #Guardo la direc donde se va a guardar el string en el nodo  

        move $a0, $v0                   #paso los argumentos a leerNodo
        li $a1, 50

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal leerNodo                    #salto a leerNodo para leer el dato 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

malloc: li $v0, 9       
        syscall # devuelve v0 con el puntero a la memoria pedida
        jr $ra 

leerNodo: 
        li $v0, 8
        syscall
