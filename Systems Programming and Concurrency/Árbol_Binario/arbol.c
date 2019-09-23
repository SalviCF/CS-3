/*
 * arbol.c
 *
 *  
 *      Author: Salvi CF
 */

#include "arbol.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

void CrearABB (TArbol *arb)
{
    *arb = NULL;
}

/*
 * Algoritmo:
 * Comprobar si el número a insertar es menor o mayor que el actual
 * iterar mientras aux != NULL o aux != NULL correspondientemente
 * insertar el elemento a partir del padre del nodo actual
 */
TArbol nuevoNodo(int elem)
{
    TArbol temp = malloc(sizeof(*temp));

    temp->valor = elem;
    temp->izq = temp->der = NULL;

    return temp;
}

void InsertarEnABB(TArbol *arb, int elem)
{
    if (*arb == NULL) {
        *arb = nuevoNodo (elem);
    }
    else {
        TArbol aux = *arb;

        bool flag = true;

        while (flag) {
            if (elem < aux->valor) {
                if (aux->izq == NULL) {
                    aux->izq = nuevoNodo(elem);
                    flag = false;
                }
                else {
                    aux = aux->izq;
                }
            }
            else if (elem > aux->valor) {
                if (aux->der == NULL) {
                    aux->der = nuevoNodo(elem);
                    flag = false;
                }
                else {
                    aux = aux->der;
                }
            }
        }
    }
}

void MostrarABB(TArbol arb)
{
    if (arb != NULL) {
        MostrarABB (arb->izq);
        if (arb->izq) printf (", ");
        printf ("%d", arb->valor);
        if (arb->der) printf (", ");
        MostrarABB (arb->der);
    }
}

void RecorrerABB(TArbol arb) {
    if (arb == NULL)
        printf ("Árbol vacío\n");
    else {
        MostrarABB(arb);
        printf ("\n");
    }
}

void DestruirABB(TArbol *arb)
{
    if (*arb != NULL) {
        DestruirABB(&((*arb)->izq));
        DestruirABB(&((*arb)->der));
        free(*arb);
        *arb = NULL;
    }
}
