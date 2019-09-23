/*
 * ListaCircular.c
 *
 *  
 *      Author: Salvi CF
 */

#include "ListaCircular.h"
#include <stdio.h>
#include <stdlib.h>

void Crear(LProc *lista)
{
    *lista = NULL;
}

void AyadirProceso(LProc *lista, int idproc)
{
    LProc nuevo = malloc(sizeof(*nuevo));
    nuevo->id = idproc;

    if (*lista == NULL) {
        *lista = nuevo;
        nuevo->sig = nuevo;
    }
    else {
        LProc aux = *lista;
        while (aux->sig != *lista)
            aux = aux->sig;
        nuevo->sig = aux->sig;
        aux->sig = nuevo;
    }
}

void MostrarLista(LProc lista)
{
    if (lista == NULL) {
        printf ("No hay procesos\n");
    }
    else {
        LProc aux = lista;

        do {
            if (aux->sig == lista)
                printf ("%d\n", aux->id);
            else
                printf ("%d -> ", aux->id);
            aux = aux->sig;
        } while (aux != lista);
    }
}

void EjecutarProceso(LProc *lista)
{
    if (*lista == NULL) {
        printf ("No hay procesos\n");
    }
    else if ((*lista)->sig == *lista) {
        free(*lista);
        *lista = NULL;
    }
    else {
        LProc aux = (*lista)->sig;
        while (aux->sig != *lista) {
            aux = aux->sig;
        }
        aux->sig = (*lista)->sig;
        aux = *lista;
        *lista = (*lista)->sig;
        free(aux);
    }
}

