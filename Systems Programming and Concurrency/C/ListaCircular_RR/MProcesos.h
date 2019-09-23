/*
 * MProcesos.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef MPROCESOS_H_
#define MPROCESOS_H_

struct TNode {
    int id;
    struct TNode *next;
};

struct TList {
    struct TNode *last;
};

typedef struct TNode *nodePtr;
typedef struct TList LProc;

void Crear(LProc *lroundrobin);
void AnadirProceso(LProc lroundrobin, int idproc);
void EjecutarProcesos(LProc lroundrobin);
void EliminarProceso(int id, LProc *lista);
void EscribirFichero(char *nomf, LProc *lista);


#endif /* MPROCESOS_H_ */
