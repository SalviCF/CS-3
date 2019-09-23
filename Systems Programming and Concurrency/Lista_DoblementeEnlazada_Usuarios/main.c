/*
 ============================================================================
 Name        : Lista_DoblementeEnlazada_Usuarios.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "listaUsuario.h"

int main(void) {

    T_userList list = createUserList();
    printUserList(list, 0);

    addUser(&list, createUser("pepe", 1, "/home/pepe"));
    printUserList(list, 0);

    addUser(&list, createUser("paco", 2, "/home/paco"));
    printUserList(list, 0);

    addUser(&list, createUser("martin", 2, "/home/martin"));
    printUserList(list, 0);

    addUser(&list, createUser("martin", 3, "/home/martin"));
    printUserList(list, 1);

    deleteUser(&list, "paco");
    printUserList(list, 1);

	return EXIT_SUCCESS;
}
