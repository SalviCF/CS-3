/*
 * libro.c
 *
 *  
 *      Author: Salvi CF
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libro.h"

Libro* CrearLibro(){
    Libro *plibro = malloc(sizeof(Libro));

    printf("Enter the title: ");
    fflush(stdout);
    scanf("%s", plibro->titulo);

    printf("Enter the author: ");
    fflush(stdout);
    scanf("%s", plibro->autor);


    printf("Enter the identification number: ");
    fflush(stdout);
    scanf("%s", plibro->isbn);

    return plibro;
}
