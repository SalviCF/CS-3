/*
 * libro.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef LIBRO_H_
#define LIBRO_H_

typedef struct Libro{
    char titulo[50];
    char autor[50];
    char isbn[13];
} Libro;

Libro* CrearLibro();


#endif /* LIBRO_H_ */
