/*
 ============================================================================
 Name        : �rbol_Binario.c
 Author      : Salvi CF

 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "arbol.h"

int main(void) {

    TArbol arb;

    CrearABB(&arb);
    InsertarEnABB(&arb, 21);
    InsertarEnABB(&arb, 5);
    InsertarEnABB(&arb, 78);
    InsertarEnABB(&arb, 1);
    InsertarEnABB(&arb, 7);
    InsertarEnABB(&arb, 45);
    InsertarEnABB(&arb, 90);
    InsertarEnABB(&arb, 4);
    InsertarEnABB(&arb, 6);
    InsertarEnABB(&arb, 15);
    InsertarEnABB(&arb, 77);
    InsertarEnABB(&arb, 80);
    InsertarEnABB(&arb, 99);
    RecorrerABB(arb);
    DestruirABB(&arb);
    RecorrerABB(arb);

	return EXIT_SUCCESS;
}
