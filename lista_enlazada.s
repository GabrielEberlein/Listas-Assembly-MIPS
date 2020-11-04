#Declaramos macros

.data 
        opcionesMenu: .asciiz "Para ver la lista presione 0, para ingresas un nuevo nodo \n1, para eliminar un nodo 2 o 3 para finalizar el programa: " 
        OpcionDos: .asciiz "Ingrese el nodo que quiere eliminar: "
        opcionUno: .asciiz "Ingrese los datos del nuevo nodo: "
        opcionZero: .asciiz "La lista es: "
        empty: .asciiz "La lista no tiene elementos\n"
        nodo: .word 0
.text

main:
        la $a0, opcionesMenu    #imprimimos las opciones
	li $v0, 4
    	syscall

        li $v0, 5               #leemos la opcion pedida por el menu
        syscall
        
        
        lw $a0, nodo($0)
        lw $a1, nodo($0)
        beq $v0, $zero, mostrarLista
        li $t0, 1
        beq $v0, $t0, condicionalNuevoNodo
        li $t0, 2
        #beq $v0, $t0, condicionalEliminarNodo
        li $t0, 3
        beq $v0, $t0, fin
        
fin:
        li $v0, 10
        syscall

condicionalNuevoNodo:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal nuevoNodo #Llamamos a nuevoNodo para el primerNodo
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        j main
        
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
        
        sw $t2, 4($v0)                  #nuevonodo -> sig = nodo
        lw $t1, 0($t2)
        sw $t1, 0($v0)                  #nuevonodo -> ant = nodo -> ant  

        sw $v0, 0($t2)                  #nodo -> ant = nuevonodo
        
        lw $t2, 0($v0)                  #t2 = nuevonodo -> ant  
        sw $v0, 4($t2)                  #t2 -> sig = nuevonodo

        move $t2, $v0

        li $a0, 50                      #pedimos 50 de espacio para el string
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal malloc                      #salto a malloc
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        sw $v0, 8($t2)                  #nuevonodo -> dato 0 string*

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


mostrarLista:
      
        beq $a1, $zero, listaVacia

        lw $a0, 8($a1)          
	li $v0, 4
	syscall

        lw $t0, 4($a1)
        move $a1, $t0
        lw $a0, nodo($0)
        bne $a1, $a0, mostrarLista

        j main
        

#mostrarPrimerNodo:
        #la $a0, 8($a0)
	#li $v0, 4
	#syscall

listaVacia:
        la $a0, empty    #decimos que la lista esta vacia 
	li $v0, 4
    	syscall

        j main

malloc: li $v0, 9       # espera en $a0 la cantidada de bytes
        syscall # devuelve v0 con el puntero a la memoria pedida
        jr $ra 

leerNodo: 
        li $v0, 8
        syscall
        jr $ra 
