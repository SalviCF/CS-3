/*
 ============================================================================
 Name        : Cola_Prioridad.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "Cola_Prioridad.h"

int main(void) {

    InsertarProceso (0, 1);
    Mostrar ();

    EjecutarProceso ();
    Mostrar ();

    InsertarProceso (0, 2);
    Mostrar ();

    InsertarProceso (0, 1);
    Mostrar ();

    InsertarProceso (1, 3);
    Mostrar ();

    InsertarProceso (2, 4);
    Mostrar ();

    InsertarProceso (3, 5);
    Mostrar ();

    EjecutarProceso ();
    Mostrar ();

    printf ("Prioridad del proceso 4: %d\n", Buscar(4));

	return EXIT_SUCCESS;
}
