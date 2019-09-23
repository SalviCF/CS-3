/*
 * Cola_Prioridad.h
 *
 *
 *      Author: Salvi CF
 */

#ifndef COLA_PRIORIDAD_H_
#define COLA_PRIORIDAD_H_

typedef struct nodo *TNodo;
struct nodo {
    unsigned int id;
    TNodo sig;
};

void Create();
void InsertarProceso(unsigned int pri, unsigned int id);
void EjecutarProceso();
int Buscar(unsigned int id);
void Mostrar();


#endif /* COLA_PRIORIDAD_H_ */
