.data 
        opcionesMenu: .asciiz  "Para ver la lista presione 0, para ingresar una nueva categoria 1, \npara modificar una categoria 2, para finalizar el programa 3: " 
        OpcionUno: .asciiz  "Ingrese la nueva categoria: "
        opcionZero: .asciiz "Lista de categorias: "
        empty: .asciiz "La lista no tiene elementos\n"

        categoriaActual: .asciiz "Estas modificando la categoria: "
        opcionesMenuCategoria: .asciiz "Para ver la categoria presione 0, para ingresar un nuevo nodo 1, \npara eliminar un nodo 2, para eliminar la categoria 3, \npara ver la siguiente categoria 4, para ver la anterior categoria 5, para volver al menu principal 6"
        mensajeEliminarNodo: .asciiz "Ingrese la id del nodo a eliminar: "

        espacio: .ascii " "

        limpiadorOOOr: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        nodo: .word 0
        
.text
        
clear:
        la $a0, limpiadorOOOr #limpia la pantalla ;)
	li $v0, 4
    	syscall
        jr $ra

        
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
        beq $v0, $t0, condicionalNuevaCategoria
        li $t0, 2
        beq $v0, $t0, menuCategorias
        li $t0, 3
        beq $v0, $t0, fin
        
menuCategorias:
        la $a0, categoriaActual
	li $v0, 4
    	syscall

        lw $a0, nodo($0)
        lw $t1, 12($a0)

        lw $a0, 8($a0)    #imprimimos la categoria
	li $v0, 4
    	syscall

        la $a0, opcionesMenuCategoria    #imprimimos las opciones
	li $v0, 4
    	syscall
            
        li $v0, 5                       #leemos la opcion pedida por el menu
        syscall
        
        beq $v0, $zero, mostrarCategoria
        li $t0, 1
        beq $v0, $t0, ingresarNodo
        li $t0, 2
        beq $v0, $t0, eliminarID
        li $t0, 3
        beq $v0, $t0, eliminarCategoria
        li $t0, 4
        beq $v0, $t0, sigCategoria
        li $t0, 5
        beq $v0, $t0, antCategoria
        li $t0, 6
        beq $v0, $t0, volverMain

fin:
        li $v0, 10
        syscall

volverMain:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal clear               #limpiamos la papantalla 
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        j main

sigCategoria:
        lw $t0, nodo($0)
        lw $t1, 4($t0)
        sw $t1, nodo($0)
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal clear               #limpiamos la papantalla 
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        j menuCategorias

antCategoria:
        lw $t0, nodo($0)
        lw $t1, 0($t0)
        sw $t1, nodo($0)

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal clear               #limpiamos la papantalla 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        j menuCategorias
        
ingresarNodo:
        lw $a0, nodo($0)
        lw $t2, 12($a0)

        beq $t2, $0, primerNodo

        lw $a3, nodo($0)
        lw $a3, 12($a3)

        lw $a3, 0($a3)

        lw $a3, 12($a3)

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal nuevoNodo #Llamamos a nuevaCategoria para el primerNodo
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        addi $a3, $a3, 1
        sw $a3, 12($t2)

        j menuCategorias

primerNodo:
        move $t0, $a0
        li $a0, 16
        
        lw $t1, nodo($0)

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal malloc 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        sw $v0, 12($t1)
        move $a0, $v0 #cargamos en $a0 la direccion del nodo

        sw $a0, 0($a0)
        sw $a0, 4($a0)                   #hacemos que el nodo apunte a si mismo
       
        move $a1, $a0
        
        li $a0, 50                      #pedimos 50 de espacio para el string

        addi $sp, $sp, -4 
        sw $ra, 0($sp)
        jal malloc                      #salto a malloc
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        move $t2, $a1
        sw $v0, 8($t2)                  #Guardo la direc donde se va a guardar el string en el nodo  

        move $a0, $v0                   #paso los argumentos a leerNodo
        li $a1, 50

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal leerNodo                    #salto a leerNodo para leer el dato 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        li $a0, 1
        sw $a0, 12($t2)

        j menuCategorias

condicionalNuevaCategoria:
        lw $t2, nodo($0)

        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal nuevoNodo #Llamamos a nuevaCategoria para el primerNodo
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        j main
         
nuevoNodo:#en $a0 recibimos la direccion de un nodo
        move $t0, $a0
        li $a0, 16
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal malloc 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        move $a0, $v0 #cargamos en $a0 la direccion del nodo
        beq $t0, $zero, primerCategoria #En caso de que la lista este vacia, llamamos a una funcion especial.
        
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
        
        sw $0, 12($t2)                  #indicamos que la clase inicia vacia

        jr $ra
  
primerCategoria: 
        
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

listaVacia:
        la $a0, empty    #decimos que la lista esta vacia 
	li $v0, 4
    	syscall

        j main

mostrarCategoria:

        beq $t1, $zero, categoriaVacia

        lw $a0, 12($t1)         #Imprimo el ID
        li $v0, 1
        syscall

        lw $a0, 8($t1)          #Imprimo el elemento
        li $v0, 4
        syscall

        lw $t1, 4($t1)
        lw $a0, nodo($0)
        lw $a0, 12($a0)

        bne $a0, $t1, mostrarCategoria

        j menuCategorias
categoriaVacia:
        la $a0, empty    #decimos que la lista esta vacia 
	li $v0, 4
    	syscall

        j menuCategorias



buscarNodo:

        lw $t0, 12($a1)                         #cargo el del nodo en t0 ID

        beq $t0, $a2, retornarNodo              #lo comparo con el id ingresado y si es ese retorno la direccion del nodo
        lw $t0, 4($a1)                          #en el caso de que no sea cargo el siguiente de nodo en t0 para compararlo con el primernodo 
        beq $t0, $a0, retornarzero              #si son iguales implica que el id buscado no esta y retorno 0
        lw $a1, 4($a1)                          #si no son iguales cargo en a1 el siguiente de a1 para seguir recorriendo la lista 
        li $v0, 0                               #por si las dudidas cargo 0 en $v0
                
        j buscarNodo

retornarzero:
        move $v0, $0
        jr $ra

retornarNodo:
        move $v0, $a1                    #retorno la direccion recibida en $a1
        jr $ra



malloc: li $v0, 9       # espera en $a0 la cantidada de bytes
        syscall         # devuelve v0 con el puntero a la memoria pedida
        jr $ra 

leerNodo: 
        li $v0, 8
        syscall
        jr $ra 

eliminarNodo:           #recibimos en $a0 la direccion del nodo a eliminar
                        #if nodo-> ant == nodo then nodo=0  / nodo[12] = 0
                        #else   $t0->sig = nodo->sig
                        #       nodo->sig->ant = $t0
        lw $t0, 0($a0)  #$t0=nodo->ant
        beq $t0, $a0, retornarzero
        lw $t1, 4($a0)  #t1 = nodo->sig
        sw $t1, 4($t0)  #nodo->ant->sig = nodo->sig
        sw $t0, 0($t1)  #nodo->sig->ant = nodo->ant
        
        lw $t2, nodo

        li $v0, 1

        bne $a1, $v0, return #peruanada para poder reusar la funcion

        sw $t0, 12($t2)
        

        jr $ra
return:
        lw $a0, 4($a0)
        sw $a0, nodo($0)
        jr $ra 
eliminarID:
        la $a0, mensajeEliminarNodo    #pedimos un entero 
	li $v0, 4
    	syscall
        
        li $v0, 5
        syscall

        lw $t0, nodo
        lw $t0, 12($t0)
        move $a0, $t0                             
        move $a1, $t0
        move $a2, $v0

        addi $sp, $sp, -4                       #recibe como parametro en a0 un nodo pibot, en a1 el mismo nodo pero que se va a ir modificando
        sw $ra, 0($sp)                          #y en a2 el entero buscado 
        jal buscarNodo                          #salto buscarnodo, devuielve en v0 la direccion del nodo 
        lw $ra, 0($sp)
        addi $sp, $sp, 4

        move $t3, $v0

        move $a0, $v0
        li $a1, 1
        addi $sp, $sp, -4                       #recibe como parametro en a0 un nodo
        sw $ra, 0($sp)                          #lo elimina ;V 
        jal eliminarNodo                        #salto Eliminarnodo, devuielve en v0 1 si la lista tenia mas de un elemento 
        lw $ra, 0($sp)                          #                                    0 si la lista tenia solo un elemento
        addi $sp, $sp, 4

        bne $v0, $0, menuCategorias

        lw $t0, nodo
        sw $0, 12($t0)

        j menuCategorias
eliminarCategoria:
        
        lw $a0, nodo($0)
        li $a1, 1

        addi $sp, $sp, -4                       #recibe como parametro en a0 un nodo
        sw $ra, 0($sp)                          #lo elimina ;V 
        jal eliminarNodo                        #salto eliminarnodo, devuielve en v0 1 si la lista tenia mas de un elemento 
        lw $ra, 0($sp)                          #                                    0 si la lista tenia solo un elemento
        addi $sp, $sp, 4

        lw $a0, nodo($0)
        lw $a0, 4($a0)
        sw $a0, nodo($0)  

        beq $v0, $0, nodoAZero

        j main

nodoAZero: 
        sw $0, nodo
        j main 