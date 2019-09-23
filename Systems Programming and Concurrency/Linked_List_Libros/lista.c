/*
 * lista.c
 *
 *  
 *      Author: Salvi CF
 */

#include <stdlib.h>
#include <string.h>
#include "lista.h"

Nodo* CrearNodo(Libro* libro){
    Nodo *nodo = (Nodo*)malloc(sizeof(Nodo));
    strncpy(nodo->libro.titulo, libro->titulo, 50);
    strncpy(nodo->libro.autor, libro->autor, 50);
    strncpy(nodo->libro.isbn, libro->isbn, 13);
    nodo->next = NULL;

    return nodo;
}

void DestruirNodo(Nodo *nodo){
    free(nodo);
}

void InsertarPrincipio(Lista *lista, Libro *libro){
    Nodo *nodo = CrearNodo(libro);
    nodo->next = lista->head;
    lista->head = nodo;
    lista->longitud++;
}

void InsertarFinal (Lista *lista, Libro *libro){
    Nodo *temp = CrearNodo(libro);
    Nodo *iter = lista->head;
    if (lista->head == NULL){
        lista->head = temp;
    } else {
        while (iter->next != NULL){
        iter = iter->next;
        }
        iter->next = temp;
    }
    lista->longitud++;
}

void InsertarDespues (int n, Lista *lista, Libro *libro){
    Nodo *temp = CrearNodo(libro);
    Nodo *iter = lista->head;

    if (n<0 || n>Contar(lista)){
    	perror("Invalid position\n");
    } else {
        if (lista->head == NULL){
            lista->head = temp;
        } else {
            int pos = 0;
            while (pos < n && iter->next != NULL){
                iter = iter->next;
                pos++;
            }
            temp->next = iter->next;
            iter->next = temp;
        }
        lista->longitud++;
    }
}

Libro* Obtener(int n, Lista *lista){
    Nodo *iter = lista->head;
    int cont = 0;
    if (lista->head == NULL){
        return NULL;
    } else {
        while (cont < n && iter->next != NULL){
        iter = iter->next;
        cont++;
        }
        if (cont != n){
            return NULL;
        } else {
            return &iter->libro; // returns a pointer
        }
    }
}

int Contar(Lista *lista){
    return lista->longitud;
}

void EliminarPrimero(Lista *lista){
    if (lista->head == NULL){
        printf("The list is already empty\n");
    } else {
        Nodo *temp = lista->head;
        lista->head = lista->head->next;
        DestruirNodo(temp);
        lista->longitud--;
    }
}

int EstaVacia(Lista *lista){
    return lista->head == NULL;
}

void EliminarUltimo(Lista *lista){
	if (lista->head == NULL){
		printf("The list is already empty\n");
	} else {
	    if (lista->head){
	        if (lista->head->next){
	            Nodo *iter, *temp;
	            iter = lista->head;
	            while (iter->next->next){//equivalent to iter->next->next != NULL
	            iter = iter->next;
	            }
	            temp = iter->next;
	            iter->next = NULL;
	            DestruirNodo(temp);
	            lista->longitud--;
	        } else {
	        	Nodo *temp = lista->head;
	            lista->head = NULL;
	            DestruirNodo(temp);
	            lista->longitud--;
	        }
	    }
	}
}

void EliminarN(int n, Lista *lista){
	if (n<0 || n>Contar(lista)){
		perror("Invalid position\n");
	} else {
	    if (lista->head){
	        if (n == 0){
	            Nodo *temp = lista->head;
	            lista->head = lista->head->next;
	            DestruirNodo(temp);
	            lista->longitud--;
	        } else if (n < lista->longitud){
	            Nodo *iter = lista->head;
	            int cont = 0;

	            while (cont < n-1){
	            iter = iter->next;
	            cont++;
	            }
	            Nodo *aux = iter->next;
	            iter->next = aux->next;
	            aux->next = NULL;
	            DestruirNodo(aux);
	            lista->longitud--;
	        }
	    }
	}
}
void MuestraLista(Lista *lista){
    if (lista->head == NULL){
        printf("The list is empty");
    } else {
        Nodo *iter = lista->head;
        while (iter){
            printf("[%s, ", iter->libro.titulo);
            printf("%s, ", iter->libro.autor);
            printf("%s] --> \n", iter->libro.isbn);
            iter = iter->next;
        }
    }
}

