/*
 ============================================================================
 Name        : Pract1_PSC.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "gestion_memoria.h"

int main(void) {

	T_Manejador manej;
	unsigned ok;
	unsigned dir;

	crear(&manej);
	mostrar(manej);

	obtener(&manej,500,&dir,&ok); /* Se ha hecho una foto. Se necesita memoria */
	if (ok) {
		mostrar(manej);
		printf("La direccion de comienzo es: %d\n", dir);
	} else {
		printf("No es posible obtener esa memoria\n");
	}

	devolver(&manej, 200,0); /* Se ha enviado parte de la foto. Ya se puede borrar */
	mostrar (manej);

	obtener(&manej,250,&dir,&ok); /* Se ha hecho otra foto */
	if (ok) {
		mostrar(manej);
		printf("La direccion de comienzo es: %d\n", dir);
	} else {
		printf("No es posible obtener esa memoria\n");
	}

	devolver(&manej,100,500); /* Se ha enviado parte de la foto. Ya se puede borrar */
	mostrar(manej);

    obtener(&manej,250,&dir,&ok); /* Se ha hecho otra foto */
	if (ok) {
		mostrar(manej);
		printf("La direccion de comienzo es: %d\n", dir);
	} else {
		printf("No es posible obtener esa memoria\n");
	}

	devolver(&manej,200,750); /* Se ha enviado parte de la foto. Ya se puede borrar */
	mostrar(manej);

	//obtenerOptimizado(&manej,50,&dir,&ok);
	//mostrar(manej);

	destruir(&manej);
	mostrar (manej);

	printf("\n**********FIN PROGRAMA**********\n\n");

	return EXIT_SUCCESS;
}
