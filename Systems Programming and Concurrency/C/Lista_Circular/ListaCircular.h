/*
 * ListaCircular.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef LISTACIRCULAR_H_
#define LISTACIRCULAR_H_

typedef struct node {
    int id;
    struct node *sig;
} *LProc;

/**
 * Crea una lista de procesos vacía.
 */
void Crear(LProc *lista);

/**
 * Añade el proceso con identificador idproc a la lista de procesos disponibles
 * para ejecución. Este proceso se añade como nodo anterior al nodo al que apunta
 * ejecución. Si la lista está vacía el puntero externo apuntará al único nodo.
 */
void AyadirProceso(LProc *lista, int idproc);

/**
 * Muestra la lista de los procesos que están disponibles para la ejecución.
 */
void MostrarLista(LProc lista);

/**
 * Simula la ejecución del proceso apuntado por ejecución, eliminándolo de la lista de procesos.
 */
void EjecutarProceso(LProc *lista);


#endif /* LISTACIRCULAR_H_ */
