/*
 ============================================================================
 Name        : Lista_Circular.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "ListaCircular.h"

int main(void) {

    LProc lista;

    Crear(&lista);
    MostrarLista(lista);

    AyadirProceso(&lista, 4);
    MostrarLista(lista);

    AyadirProceso(&lista, 6);
    MostrarLista(lista);

    EjecutarProceso(&lista);
    MostrarLista(lista);

    EjecutarProceso(&lista);
    MostrarLista(lista);

    AyadirProceso(&lista, 1);
    MostrarLista(lista);

    AyadirProceso(&lista, 8);
    MostrarLista(lista);

    AyadirProceso(&lista, 3);
    MostrarLista(lista);

    AyadirProceso(&lista, 5);
    MostrarLista(lista);

    EjecutarProceso(&lista);
    MostrarLista(lista);


	return EXIT_SUCCESS;
}
