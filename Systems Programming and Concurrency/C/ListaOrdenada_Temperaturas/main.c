/*
 ============================================================================
 Name        : ListaOrdenada_Temperaturas.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "lista.h"

int main(void) {

    TLista  l;
    int     ok;

    crear (&l);
    mostrar (l);

    insertar_muestra (3, 23.0, &l);
    insertar_muestra (2, 22.0, &l);
    mostrar (l);

    insertar_muestra (8, 28.0, &l);
    mostrar (l);

    insertar_muestra (5, 25.0, &l);
    mostrar (l);

    insertar_muestra (2, 22.0, &l);
    mostrar (l);

    borrar_muestra (7, &l, &ok);
    if ( !ok )
        printf ("No se pudo borrar 7\n");
    else
        printf ("Elemento 7 borrado\n");

    mostrar (l);

    insertar_muestra (7, 27.0, &l);
    mostrar (l);

    borrar_muestra (7, &l, &ok);
    if ( !ok )
        printf ("No se pudo borrar 7\n");
    else
        printf ("Elemento 7 borrado\n");

    mostrar (l);

    printf ("Promedio temperatura: %.2f\n", promedio_temp (l, 24.0));

    borrar_muestra (2, &l, &ok);
    if ( !ok )
        printf ("No se pudo borrar 2\n");
    else
        printf ("Elemento 2 borrado\n");

    mostrar (l);

    destruir (&l);

    mostrar (l);

    return EXIT_SUCCESS;
}
