/*
 ============================================================================
 Name        : Estructura_Hebras.c
 Author      : Salvi CF

 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sistema.h"

int main(void) {

	  LSistema l;
	  char idh[3];

	  Crear(&l);
	  Mostrar(l);

	  InsertarProceso(&l, 4);
	  Mostrar(l);

	  InsertarProceso(&l, 6);
	  Mostrar(l);

	  strcpy(idh,"h1");
	  InsertarHebra(&l, 6, idh, 7);
	  Mostrar(l);

	  strcpy(idh,"h3");
	  InsertarHebra(&l, 6, idh, 1);
	  Mostrar(l);

	  InsertarProceso(&l, 1);
	  Mostrar(l);

	  InsertarProceso(&l, 2);
	  Mostrar(l);

	  strcpy(idh,"h2");
	  InsertarHebra(&l, 6, idh, 4);
	  Mostrar(l);

	  strcpy(idh,"h8");
	  InsertarHebra(&l, 2, idh, 3);
	  Mostrar(l);

	  strcpy(idh,"h5");
	  InsertarHebra(&l, 2, idh, 2);
	  Mostrar(l);

	  strcpy(idh,"h7");
	  InsertarHebra(&l, 2, idh, 10);
	  Mostrar(l);

	  InsertarProceso(&l, 5);
	  Mostrar(l);

	  EliminarProc(&l, 6);
	  Mostrar(l);

	  Destruir(&l);
	  Mostrar(l);


	  return EXIT_SUCCESS;
}
