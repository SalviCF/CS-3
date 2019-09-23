/*
 * lista.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef LISTA_H_
#define LISTA_H_

#include <stdio.h>
#include "libro.h"

typedef struct Nodo{
    Libro libro;
    struct Nodo *next;
} Nodo;

typedef struct Lista{
    Nodo *head;
    int longitud;
} Lista;

Nodo* CrearNodo(Libro* libro);
void DestruirNodo(Nodo *nodo);

void InsertarPrincipio(Lista *lista, Libro *libro);
void InsertarFinal (Lista *lista, Libro *libro);
void InsertarDespues (int n, Lista *lista, Libro *libro);
Libro* Obtener(int n, Lista *lista);
int Contar(Lista *lista);
void EliminarPrimero(Lista *lista);
int EstaVacia(Lista *lista);
void EliminarUltimo(Lista *lista);
void EliminarN(int n, Lista *lista);
void MuestraLista(Lista *lista);


#endif /* LISTA_H_ */
