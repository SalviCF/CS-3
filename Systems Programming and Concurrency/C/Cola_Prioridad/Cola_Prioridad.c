/*
 * Cola_Prioridad.c
 *
 *  
 *      Author: Salvi CF
 */

#include <stdio.h>
#include <stdlib.h>
#include "Cola_Prioridad.h"

#define MAXPRI 4

TNodo array[MAXPRI];

/**
 * Inicializa el array.
 */
void Create()
{
    for (int i = 0; i < MAXPRI; ++i)
        array[i] = NULL;
}

TNodo NuevoNodo(unsigned int id)
{
    TNodo nodo = (TNodo) malloc(sizeof(nodo));
    if (nodo) {
        nodo->id = id;
        nodo->sig = NULL;
    }
    return nodo;
}

TNodo UltimoNodo(TNodo nodo)
{
    if (nodo) {
        while (nodo->sig)
            nodo = nodo->sig;
    }
    return nodo;
}

/**
 * Dada una prioridad y un identificador de proceso, lo añade al final de la lista
 * que le corresponde.
 */
void InsertarProceso(unsigned int pri, unsigned int id)
{
    TNodo nuevo = NuevoNodo(id);
    TNodo ultimo = UltimoNodo(array[pri]);
    if (ultimo)
        ultimo->sig = nuevo;
    else
        array[pri] = nuevo;
}

/**
 * Elimina de la lista el proceso más prioritario que le corresponde ejecutarse.
 * Si no existen procesos por ejecutar se indicará con un mensaje de aviso.
 */
void EjecutarProceso()
{
    int encontrado = 0;

    for (int pri = MAXPRI-1; pri >= 0  &&  !encontrado; --pri) {
        // Si hay procesos en la lista de prioridad pri
        if (array[pri]) {
            // Borrar el primer proceso
            TNodo temp = array[pri];
            array[pri] = array[pri]->sig;
            free(temp);
            encontrado = 1;
        }
    }

    if (!encontrado)
        printf("No hay procesos");
}

/**
 * Dado un identificador de proceso devuelve la prioridad de éste. Si el id del
 * proceso no existe se devolverá -1.
 */
int Buscar(unsigned int id)
{
    int encontrado = -1;
    for (int pri = 0; pri < MAXPRI  &&  encontrado == -1; ++pri)
        for (TNodo aux = array[pri]; aux; aux = aux->sig)
            if (aux->id == id)
                encontrado = pri;

    return encontrado;
}

void Salida(TNodo nodo)
{
    if (nodo) {
            printf ("%d", nodo->id);
        for (nodo = nodo->sig; nodo; nodo = nodo->sig) {
            printf (" -> %d", nodo->id);
        }
    }
}

/**
 * Recorre la estructura para mostrar los procesos existentes que están disponibles
 * para ejecución ordenados por prioridad.
 */
void Mostrar()
{
    for (int pri = MAXPRI-1; pri >= 0; --pri) {
        printf("Cola de prioridad %d: ", pri);
        Salida(array[pri]);
        putchar('\n');
    }
    putchar('\n');
}
