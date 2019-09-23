/*
 * lista.h
 *
 *  
 *      Author: Salvi CF
 */

#include  <stdio.h>
#include  <stdlib.h>

#ifndef LISTA_H_
#define LISTA_H_

typedef struct  node
{
    int    id;
    float  temp;
    struct node  *next;
}  *TLista, node;

void  crear (TLista  *l);
void  mostrar (TLista  l);
void  destruir (TLista  *l);
void  insertar_muestra (int  id, float  temp, TLista *l);
void  borrar_muestra (int  id, TLista  *l, int  *ok);
float  promedio_temp (TLista  l, float  umbral);

#endif /* LISTA_H_ */
