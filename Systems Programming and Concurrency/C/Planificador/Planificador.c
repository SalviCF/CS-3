/*
 * Planificador.c
 *
 * 
 *      Author: Salvi CF
 */

#include "Planificador.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Inicializa el planificador creando un planificador vacío.
 */
void crear(T_Planificador *planif)
{
    *planif = NULL;
}
/*-----------------------------------------------------------------------------*/
T_Planificador crear_nodo(int pri, char *id, T_Planificador s)
{
    T_Planificador nuevo = malloc(sizeof(*nuevo));

    if (nuevo != NULL) {
        nuevo->pri = pri;
        nuevo->id = id;
        nuevo->sig = s;
    }

    return nuevo;
}

/**
 * Inserta una nueva tarea id de prioridad pri en el planificador planif.
 * La lista está ordenada por prioridad y en el caso de que exista una tarea
 * con la misma prioridad se almacenará por orden de llegada.
 * El identificador de tarea es único.
 */
void insertar_tarea(T_Planificador *planif, int pri, char *id)
{
    T_Planificador nueva = crear_nodo(pri, id, NULL); // Crear nueva tarea

    if (nueva) {
        // Si la lista está vacía
        if (!(*planif)) {
            *planif = nueva;
        } else {
            // Si la prioridad de la nueva tarea es mayor
            if (pri > (*planif)->pri) {
                // Insertar nueva antes que la primera
                nueva->sig = *planif;
                *planif = nueva;
            }
            else {
                T_Planificador aux = *planif;

                while (aux->sig != NULL  &&  aux->sig->pri > pri) {
                    aux = aux->sig;
                }
                nueva->sig = aux->sig;
                aux->sig = nueva;
            }
        }
    }
}

/**
 * Muestra el estado del planificador.
 */
void mostrar(T_Planificador planificador)
{
    if (planificador == NULL)
        printf ("Lista vacía\n");
    else {
        while (planificador != NULL) {
            printf("[%d, %s]", planificador->pri, planificador->id);
            if (planificador->sig != NULL)
                printf(" -> ");
            planificador = planificador->sig;
        }
        printf("\n");
    }
}
/**
 * Dado un planificador, elimina una tarea id que está preparada para ejecución.
 * En el caso de que no exista dicha tarea, se devolverá 0 en el parámetro ok.
 * OK valdrá 1 en el caso de que se haya realizado el borrado.
 */
void eliminar_tarea(T_Planificador *planif, char *id, unsigned *ok)
{
    T_Planificador actual = *planif;
    T_Planificador anterior = NULL;
    *ok = 0;

    while (actual != NULL  &&  strcmp(id, actual->id) != 0) {
        anterior = actual;
        actual = actual->sig;
    }

    if (anterior == NULL) {
        *planif = (*planif)->sig;
        free(actual);
    }
    else if (actual != NULL) {
        anterior->sig = actual->sig;
        free(actual);
        *ok = 1;
    }
}

/**
 * Extrae de la estructura la tarea que le corresponde ejecutarse.
 */
void planificar(T_Planificador *planif)
{
    if (*planif != NULL) {
        T_Planificador temp = *planif;
        *planif = (*planif)->sig;
        free(temp);
    }
}

/**
 * Destruye toda la estructura eliminando y liberando la memoria de todos los nodos.
 */
void destruir(T_Planificador *planif)
{
    T_Planificador temp;

    while (*planif != NULL) {
        temp = *planif;
        *planif = (*planif)->sig;
        free(temp);
    }
}
