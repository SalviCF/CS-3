/*
 ============================================================================
 Name        : impresora.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "impresora.h"

void crearlista(TLista *lista)
{
    (*lista)=NULL;
}


void insertar_trabajo(TLista *lista, struct Trabajo t, int *ok)
{
    TLista ptr,ant,nuevonodo;
    int encontrado=0;
    *ok=0;
    ptr=*lista;
	while ((ptr!=NULL)&&(encontrado==0)){
		if((strcmp(ptr->trabajo.fichero, t.fichero)==0) && (ptr->trabajo.equipo==t.equipo)
				&& (ptr->trabajo.prioridad))
        {
			ptr->trabajo.numcopias+=t.numcopias;

			encontrado=1;
		}
		ptr=ptr->sig;
	}

if (encontrado==0) //es decir si no estaba ese trabajo ya encolado
{
    nuevonodo=(TLista)malloc(sizeof(struct Trabajoimpresion));
    nuevonodo->trabajo=t;
    nuevonodo->sig=NULL;
    if ((*lista)==NULL)
    {

        (*lista)=nuevonodo;
    }
    else
    {   ant=NULL;
        ptr=*lista;
        while ((ptr!=NULL) && (ptr->trabajo.prioridad<=t.prioridad))
        {
            ant=ptr;
            ptr=ptr->sig;
        }
        ant->sig=nuevonodo;
        nuevonodo->sig=ptr;
    }
    *ok=1;
}/*del inf encontrado*/
}

void mostrar_lista(TLista lista, int prioridad)
{
    TLista l;
    l=lista;
    while (l!=NULL)
    {
    	printf("[Cod: %d | ", l->trabajo.codtrabajo);
    	printf("Nombre: %s | ", l->trabajo.fichero);
        printf("Equipo: %d | ", l->trabajo.equipo);
        printf("Prior: %d | ", l->trabajo.prioridad);
        printf("Copias: %d] -->", l->trabajo.numcopias);
        l=l->sig;
    }
}

void aumentaprioridad(TLista *lista,int codtrabajo){
	TLista antptr,ptr, ptrant, ptr2;
	int encontrado=0;
	antptr=NULL;
	ptr=*lista;
	ptrant=NULL;
	ptr2=*lista;

	while ((ptr!=NULL)&&(encontrado==0)){
		if ((ptr->trabajo.codtrabajo==codtrabajo)&&(ptr->trabajo.prioridad>1)){
			ptr->trabajo.prioridad--;
			encontrado=1;
		}
		if(encontrado==0){
			antptr=ptr;
			ptr=ptr->sig;
		}
	}
//En ptr apunto al nodo que voy a cambiar de prioridad
if (encontrado==0)
{
    printf("Ese trabajo no existe\n");
}
else
{   int cambiado=0;
    printf("Se comienza a cambiar el proceso de orden: \n");
	while ((ptr2!=NULL)&& (cambiado==0)){
		if(ptr2->trabajo.prioridad>ptr->trabajo.prioridad){
            cambiado=1;
			if(ptrant==NULL){
				ptr->sig=ptr2;
				*lista=ptr;
			}
			else {
				ptrant->sig=ptr;
				antptr->sig=ptr->sig;
				ptr->sig=ptr2;
			}
		}//del if
		ptrant=ptr2;
		ptr2=ptr2->sig;
	}
}//del else
}


void imprimir(TLista *lista, int *ok)
{
    TLista aux;
    if (*lista!=NULL)
    {
    aux=*lista;
    *lista=(*lista)->sig;
    free(aux);

    }
    else
        printf("No hay trabajos que imprimir\n");

}

void destruir(TLista *lista)
{
    TLista aux;

    while (*lista!=NULL)
    {
        aux=*lista;
        *lista=(*lista)->sig;
        free(aux);
    }
}

void volcado(TLista *lista)
{
    TLista aux;
    FILE *f;
    struct Trabajo t;
    f=fopen("TRABAJOS.BIN","wb");
    if (f==NULL)
        printf("Error de apertura\n");
    else
    {
    while (*lista!=NULL)
    {
    t=(*lista)->trabajo;
    fwrite(&t,sizeof(t),1,f);
    aux=*lista;
    *lista=(*lista)->sig;
    free(aux);
    }
    }
fclose(f);
}

void carga(TLista *lista)
{
    FILE *f;
    struct Trabajo t;
    int ok;
    f=fopen("TRABAJOS.BIN","rb");
    if (f==NULL)
        printf("Fichero inexistente\n");
    else
    {
        while (!feof(f))
        {
          fread(&t,sizeof(t),1,f)    ;
          if (!feof(f))
            insertar_trabajo(lista,t,&ok);
        }

    }
    fclose(f);
}

void eliminatrabajos(TLista *lista, int codequipo){
	int equipoptr;
	TLista ptr,aux,ant;
	ptr=*lista;
	ant=NULL;
	while(ptr!=NULL){
		equipoptr=ptr->trabajo.equipo;
		if(equipoptr==codequipo){//hay que eliminar
			aux=ptr;
			if (ant==NULL)
            {
               *lista=(*lista)->sig;
               free(aux);
               ptr=*lista;
            }
            else
            {
			ptr=ptr->sig;
			ant->sig=ptr;
			free(aux);
            }//del eliminar

		}else{
			ant=ptr;
			ptr=ptr->sig;
		}

	}
}
