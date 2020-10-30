# hacemos algunos macros para facilitar el código

    .eqv nodo_sig    0
    .eqv nodo_val    4
    .eqv nodo_tamano 8

    .data
mensaje:     .asciiz "(1) Ingresar nuevo nodo.\n(2) Eliminar ultimo nodo.\n(3) Mostrar lista.\n"
mensaje2:    .asciiz "Ingrese el dato: "
max:         .word 50
primer_elem: .word 0
lista:

    .text
main:   li $s0,0 # inicializamos la lista como vacía
        jal operaciones

operaciones:
        la $a0, mensaje # mostramos en pantalla las operaciones a elegir
        li $v0, 4
        syscall

        li $v0, 5
        syscall
        move $t0, $v0 # guardamos el valor ingresado por el usuario
                      # para verificar la opción a realizar

        li $t1, 1 # guardamos el valor de las operaciones en t1 para poder
                  # comparar a t0 con beq
        beq $t0, $t1, anadir
        li $t1, 2
        beq $t0, $2, eliminar
        li $t1, 3
        beq $t0, $3, mostrar1

# s0 = primer elemento
# s1 = puntero al nodo actual
# s2 = puntero al último nodo creado
# s3 = puntero al valor

anadir: addi $sp, $sp, -8 # reservamos espacio en la pila para guardar $ra
        sw $ra, 4($sp)
        sw $s0, 4($sp)

        jal ingresar_valor # devuelve el puntero del valor
        move $s3, $v0 # lo guardamos en el registro s

        li $a0, nodo_tamano # definimos el tamaño del nodo como 8
        jal malloc
        move $s2, $v0 # guardamos el puntero en s2

        beq $s0, $0, vacio # verificamos que la lista no esté vacía,
                           # sino añadimos el nodo en la cabeza
        addi $s3, $s0, 0 # si no es vacía, copiamos la dirección del elemento en s1
        jal insertar1
        li $s1, 0
        j menu

eliminar: # baia baia, acá no hay nada. F.

mostrar1: addi $s1, $s0, 0 # seteamos como nodo actual al primer nodo de la lista

mostrar2: # imprimimos el nodo
         li $a0, nodo_val($s4) # mandamos el valor del nodo como parámetro a imprimir
         li $v0, 4
         syscall

         # cargamos el siguiente nodo
         lw $t3, nodo_sig($s1)
         li $s1, 0
         addi $s1, $t3, 0

         bnq $s0, nodo_sig($s1), mostrar2 # si el siguiente nodo no es el último,
                                   # hacemos un ciclo

         # imprimimos el último nodo
         la $a0, nodo_val($s1) # mandamos el valor del nodo como parámetro a imprimir
         li $v0, 4
         syscall

         j menu # volvemos al menu

#-----------------------------

vacio : move $s0, $s2
        sw $s1, nodo_val($s0) # almacenamos al valor en el nodo actual, ya que está vacío
        sw $s0, nodo_sig($s0) # almacenamos el valor en el nodo actual
        li $s3, 0 # seteamos en 0 los punteros al valor y al último nodo
        li $s2, 0
        j $ra # regresamos a la operación añadir

insertar1:
        beq $s0, nodo_sig($s3), insertar2 # si el siguiente nodo es igual al
                                   # primero, terminamos el ciclo

        # cargamos el nodo siguiente en s3. Para esto, guardamos el
        # nodo siguiente en t3, seteamos s3 en 0 y le sumamos t3
        lw $t3, nodo_sig($s3)
        li $s3, 0
        addi $s3, $t3, 0

        j insertar1 # hacemos un ciclo

insertar2: # actualizamos los valores del nodo actual
         sw $s2, nodo_sig($s1) # marcamos como último nodo creado (s2) al nodo siguiente nodo_sig($s1)
         sw $s1, nodo_val($s2) # como nodo actual (s1), al último nodo creado (s2)
         sw $s0, nodo_sig($s2) # como primer elemento (s0), al último nodo
         j $ra # regresamos a la operación añadir

ingresar_valor:
         # guardamos $ra en la pila
         addi $sp, $sp, -8
         sw $ra, 4($sp)
         sw $s0, 4($sp)

         lw $a0, nodo_tamano # guardamos el tamaño máximo del nodo en a0 (8, nodo_tamano) como parámetro
         jal malloc # generamos espacio para el valor del nodo
         move $a0, v0 # guardamos el puntero a la memoria, devuelto por malloc, en a0
         lw $a1, nodo_tamano # indicamos el tamaño máximo del nodo
         li $v0, 8 # leemos el valor que ingresará el usuario
         syscall

         move $v0, $a0 # restauramos la dirección del valor

         # modificamos la pila para modificar $ra y volver a la anterior operación
         lw $s0, 4($sp)
         lw $ra, 4($sp)
         addi $sp, $sp, 8
         jr $ra

malloc: li $v0, 9
        syscall # devuelve v0 con el puntero a la memoria pedida
        jr $ra # volvemos a ingresar_valor
