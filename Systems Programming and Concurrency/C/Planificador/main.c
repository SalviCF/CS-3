/*
 ============================================================================
 Name        : Planificador.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "Planificador.h"


int main()
{
    T_Planificador planif;
    unsigned ok;

    crear(&planif);
    mostrar(planif);

    insertar_tarea(&planif, 8, "t1");
    mostrar(planif);

    insertar_tarea(&planif, 8, "t2");
    mostrar(planif);

    insertar_tarea(&planif, 4, "t8");
    mostrar(planif);

    insertar_tarea(&planif, 3, "t7");
    mostrar(planif);

    insertar_tarea(&planif, 1, "t3");
    mostrar(planif);

    eliminar_tarea(&planif, "t8", &ok);
    mostrar(planif);

    planificar(&planif);
    mostrar(planif);

    destruir(&planif);
    mostrar(planif);

	return EXIT_SUCCESS;
}
