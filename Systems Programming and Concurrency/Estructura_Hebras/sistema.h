/*
 * sistema.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef SISTEMA_H_
#define SISTEMA_H_

typedef struct hebra {
    char *id;
    int pri;
    struct hebra *sig;
} Hebra;

typedef struct nodo {
    int id;
    struct nodo *sig;
    Hebra *hebra;
} Proceso, *LSistema;

void Crear (LSistema *ls);
void InsertarProceso ( LSistema *ls, int idproc);
void InsertarHebra (LSistema *ls, int idproc, char *idhebra, int priohebra);
void Mostrar (LSistema ls);
void EliminarProc (LSistema *ls, int idproc);
void Destruir (LSistema *ls);


#endif /* SISTEMA_H_ */
