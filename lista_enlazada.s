#Declaramos macros

.data 
        nodo: .word 0
.text

main:
        li $t0, 1
        li $v0, 1
        lw $a0, nodo
        beq $v0, $t0, condicionalNuevoNodo
        
fin:
        jr $ra

condicionalNuevoNodo:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal nuevoNodo 
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        li $t0, 1
        li $v0, 1
        lw $a0, nodo
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal nuevoNodo 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        j fin 
        
nuevoNodo:#en $a0 recibimos la direccion de un nodo
        move $t0, $a0
        li $a0, 12
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal malloc 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        move $a0, $v0 #cargamos en $a0 la direccion del nodo
        beq $t0, $zero, primerNodo #En caso de que la lista este vacia, llamamos a una funcion especial.
        
        lw $t2, nodo($0)
        
        sw $t2, 0($v0)                  #nuevonodo -> ant = nodo
        lw $t1, 4($t2)
        sw $t1, 4($v0)                  #nuevonodo -> sig = nodo -> sig  

        sw $v0, 4($t2)                  #nodo -> sig = nuevonodo
        
        lw $t2, 4($v0)                  #t2 = nuevonodo -> sig  
        sw $v0, 0($t2)                  #t2 -> ant = nuevonodo

        move $t2, $v0

        li $a0, 50                      #pedimos 50 de espacio para el string
        addi $sp, $sp, -4 
        sw $ra, 0($sp)
        jal malloc                      #salto a malloc
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        sw $v0, 8($t2)                  #nuevonodo -> dato 0 string*
        sw $t2, nodo($0)

        move $a0, $v0                   #paso los argumentos a leerNodo
        li $a1, 50

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal leerNodo                    #salto a leerNodo para leer el dato 
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        jr $ra
  
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
        
        lw $t2, nodo($0)
        sw $v0, 8($t2)                  #Guardo la direc donde se va a guardar el string en el nodo  

        move $a0, $v0                   #paso los argumentos a leerNodo
        li $a1, 50

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal leerNodo                    #salto a leerNodo para leer el dato 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        jr $ra

malloc: li $v0, 9       
        syscall # devuelve v0 con el puntero a la memoria pedida
        jr $ra 

leerNodo: 
        li $v0, 8
        syscall
        jr $ra 
