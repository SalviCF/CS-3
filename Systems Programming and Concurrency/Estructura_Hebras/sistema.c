/*
 * sistema.c
 *
 *  
 *      Author: Salvi CF
 */

#include "sistema.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Crea una lista vacia.
 */
void Crear(LSistema *ls)
{
  *ls = NULL;
}

Proceso* CrearProceso(int idproc, Proceso *sig, Hebra *hebra)
{
  Proceso *p = malloc(sizeof(*p));

  if (p) {
    p->id = idproc;
    p->sig = sig;
    p->hebra = hebra;
  }
  return p;
}

Proceso* ObtenerUltimo(LSistema *ls)
{
  Proceso *aux = *ls;
  if (aux)
    while (aux->sig) aux = aux->sig;
  return aux;
}

/**
 * Inserta un proceso por orden de llegada.
 */
void InsertarProceso(LSistema *ls, int idproc)
{
  Proceso* ultimo = ObtenerUltimo(ls);
  Proceso* nuevo = CrearProceso(idproc, NULL, NULL);
  if (nuevo) {
    if (ultimo) {
      ultimo->sig = nuevo;
    } else {
      *ls = nuevo;
    }
  }
}

Proceso* BuscarProceso(LSistema *ls, int idproc)
{
  Proceso *p = *ls;
  while (p && p->id != idproc) {
    p = p->sig;
  }
  return p;
}

Hebra* NuevaHebra(char *idhebra, int priohebra)
{
  Hebra *nueva = malloc(sizeof(nueva));
  if (nueva) {
    nueva->id = strdup(idhebra);
    nueva->pri = priohebra;
    nueva->sig = NULL;
  }
  return nueva;
}

/**
 * Inserta una hebra en el proceso con identificador idproc teniendo en cuenta el orden
 * de prioridad (mayor a menor). Se puede suponer que el proceso idproc siempre existe.
 */
void InsertarHebra(LSistema *ls, int idproc, char *idhebra, int priohebra)
{
  Proceso *p = BuscarProceso(ls, idproc);
  Hebra *nueva = NuevaHebra(idhebra, priohebra);

  if (nueva) {
    Hebra *aux = p->hebra;
    if (aux) {
      if (priohebra > aux->pri) {
        p->hebra = nueva;
        nueva->sig = aux;
      } else {
        while (aux->sig  &&  aux->sig->pri > priohebra)
          aux = aux->sig;
        nueva->sig = aux->sig;
        aux->sig = nueva;
      }
    } else {
      p->hebra = nueva;
    }
  }
}

/**
 * Muestra el contenido del sistema.
 */
void Mostrar(LSistema ls)
{
  if (!ls)
    printf("No hay procesos\n");
  while (ls) {
    printf("[%i] ", ls->id);
    Hebra *h = ls->hebra;
    while (h) {
      printf("[%s, %d]", h->id, h->pri);
      if (h->sig) printf("->");
      h = h->sig;
    }
    ls = ls->sig;
    printf("\n");
  }
  printf("\n");
}

void EliminarHebras(Proceso *p)
{
  Hebra *temp, *h = p->hebra;
  while (h) {
    temp = h->sig;
    free(h);
    h = temp;
  }
}

/**
 * Elimina del sistema el proceso con identificador idproc liberando la memoria de
 * éste y de sus hebras.
 */
void EliminarProc(LSistema *ls, int idproc)
{
  Proceso *aux = *ls, *prev;
  if (aux  &&  aux->id == idproc) {
    *ls = aux->sig;
    EliminarHebras(aux);
    free(aux);
    return;
  }
  while (aux  &&  aux->id != idproc) {
    prev = aux;
    aux = aux->sig;
  }
  if (aux) {
    prev->sig = aux->sig;
    EliminarHebras(aux);
    free(aux);
  }
}

/**
 * Destruye toda la estructura liberando su memoria.
 */
void Destruir(LSistema *ls)
{
  Proceso *temp;
  while(*ls) {
    temp = (*ls)->sig;
    EliminarHebras(*ls);
    free(*ls);
    *ls = temp;
  }
}
