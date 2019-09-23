/*
 * Planificador.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef PLANIFICADOR_H_
#define PLANIFICADOR_H_

typedef struct node {
    char *id;
    int pri;
    struct node *sig;
} *T_Planificador;

void crear(T_Planificador *planif);
T_Planificador crear_nodo(int pri, char *id, T_Planificador s);
void insertar_tarea(T_Planificador *planif, int pri, char *id);
void mostrar(T_Planificador planificador);
void eliminar_tarea(T_Planificador *planif, char *id, unsigned *ok);
void planificar(T_Planificador *planif);
void destruir(T_Planificador *planif);


#endif /* PLANIFICADOR_H_ */
