/*
 * gestion_memoria.c
 *
 *  
 *      Author: Salvi CF
 */

#include <stdio.h>
#include <stdlib.h>
#include "gestion_memoria.h"

void crear(T_Manejador *manejador){
    printf("Se ha creado la estructura para gestionar laa memoria\n\n");
    *manejador = malloc(sizeof(struct T_Nodo));
    (*manejador)->inicio = 0;
    (*manejador)->fin = MAX-1;
    (*manejador)->sig = NULL;
}

void mostrar (T_Manejador manejador){
    printf("Estado de la memoria de alto rendimiento\n");
    printf("Bloques disponibles:\t");
    T_Manejador iter = manejador;
    if (iter == NULL){
        printf("(manejador) --> (NULL)\n");
    } else {
        if (iter->inicio == -1){
        printf("There are no available blocks\n");
        } else {
            printf("(manejador) --> ");
            while (iter != NULL){
                printf("[%d,%d] --> ", iter->inicio, iter->fin);
                iter = iter->sig;
            } printf("(NULL)");
        }
        printf("\n");
    }
}

void obtener(T_Manejador *manejador, unsigned tam, unsigned* dir, unsigned* ok){
    printf("\n<<Cambios en la memoria>>: Solicitud de un bloque de: %d\n\n", tam);
    T_Manejador iter, prev;
    iter = *manejador;

    *ok = 0;

    if ((*manejador)->sig == NULL){ //first request of memory (one block)
        if (tam > MAX){ *ok = 0; }
        else { *ok = 1; }
    } else {
        while (iter != NULL && *ok == 0){
            if ((iter->fin - iter->inicio +1) >= tam){
                *ok = 1;
                break;
            }
            prev = iter;
            iter = iter->sig;
        }
    }

    if (*ok == 1){ //request successful
        if (tam == (iter->fin - iter->inicio +1)){ //obtain the entire block (free node)
            if (iter == *manejador && iter->sig == NULL){ //only one block
                *dir = iter->inicio;
                iter->inicio = iter->fin = -1; //indicates that there are no blocks
            } else { //several blocks: fix up links
                if (iter == *manejador){ //head involved
                    *dir = iter->inicio;
                    *manejador = (*manejador)->sig;
                    iter->sig = NULL;
                    free(iter);
                } else {
                    *dir = iter->inicio;
                    prev->sig = iter->sig;
                    iter->sig = NULL;
                    free(iter);
                }
            }
        } else { //only change start and end in the block/node
            *dir = iter->inicio;
            iter->inicio = (iter->inicio)+tam;
        }
    }
}

void devolver(T_Manejador *manejador,unsigned tam,unsigned dir){
    printf("\n<<Cambios en la memoria>>: Se devuelve un trozo de %d con inicio"
           " situado en %d\n\n", tam, dir);
    T_Manejador iter, temp;
    iter = *manejador;
    temp = malloc(sizeof(struct T_Nodo));
    temp->inicio = dir;
    temp->fin = dir+tam-1;
    temp->sig = NULL;

    while (iter->sig != NULL && (iter->sig)->inicio < dir){ //place in order
        iter = iter->sig;
    }

    //Second condition controls insertion in second location
    if (iter == *manejador && iter->inicio>dir){
        temp->sig =iter;
        (*manejador) = temp;
    } else {
        temp->sig = iter->sig;
        iter->sig = temp;
    }
}

void destruir(T_Manejador* manejador){
    printf("\nSe ha destruido la estructura para gestionar la memoria\n\n");
    T_Manejador iter, prev;
    iter = prev = *manejador;
    while (iter->sig != NULL){
        prev = iter;
        iter = iter->sig;
        prev->sig = NULL;
        free(prev);
    }
    free(iter);
    *manejador = NULL;
}

void obtenerOptimizado(T_Manejador *manejador,unsigned tam, unsigned *dir, unsigned *ok){
    printf("\n<<Cambios en la memoria>>: Solicitud OPTIMIZADA de un bloque de: %d\n\n", tam);
    T_Manejador iter, prev, opt;
    iter = *manejador;

    *ok = 0;

    int dif_current, dif_min;
    dif_min = MAX;

    if ((*manejador)->sig == NULL){ //first request of memory (one block)
        if (tam > MAX){ *ok = 0; }
        else { *ok = 1; }
    } else {
        while (iter != NULL){
            if ((iter->fin - iter->inicio +1) >= tam){
                dif_current = (iter->fin - iter->inicio +1) - tam;
                *ok = 1;
                if (dif_current < dif_min){
                    dif_min = dif_current;
                    opt = iter;
                    if (dif_min == 0){ break; }//stop searching (better option)
                }
            }
            prev = iter;
            iter = iter->sig;
        }
    }

    if (iter == NULL){iter=prev;}

    if (*ok == 1){ //request successful
        if (tam == (iter->fin - iter->inicio +1)){ //obtain the entire block (free node)
            if (iter == *manejador && iter->sig == NULL){ //only one block (memory become empty)
                *dir = iter->inicio;
                iter->inicio = iter->fin = -1; //indicates that there are no blocks
            } else { //several blocks: fix up links
                if (iter == *manejador){//done
                    *dir = opt->inicio;
                    *manejador = (*manejador)->sig;
                    opt->sig = NULL;
                    free(opt);
                } else {//done
                    *dir = opt->inicio;
                    prev->sig = opt->sig;
                    opt->sig = NULL;
                    free(opt);
                }
            }
        } else { //only change start and end in the block/node
            *dir = opt->inicio;
            opt->inicio = (opt->inicio)+tam;
        }
    }
}

void mostrarTodos (T_Manejador manejador){
    printf("Estado de la memoria de alto rendimiento\n");
    printf("Bloques disponibles y ocupados:\t");
    T_Manejador iter, iter2;
    iter = iter2 = manejador;

    if (iter == NULL){
        printf("(manejador) --> (NULL)\n");
    } else {
        if (iter->inicio == -1){
        printf("There are no available blocks\n");
        } else { // real print
            printf("(manejador) --> ");
            while (iter != NULL){
                printf("[%d,%d] --> ", iter->inicio, iter->fin);


                iter = iter->sig;
            } printf("(NULL)");
        }
        printf("\n");
    }
}

