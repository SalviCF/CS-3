/*
 * lista.c
 *
 *  
 *      Author: Salvi CF
 */

#include  "lista.h"

/* Crea una lista vacía */
void  crear (TLista  *l)
{
    *l = NULL;
}

/* Muestra los elementos de una lista */
void  mostrar (TLista  l)
{
    if ( l == NULL )
        printf ("Empty\n");
    else {
        printf ("[ ID: %d, TEMP: %.2f ]", l->id, l->temp);
        l = l-> next;

        while ( l != NULL ) {
            printf ("[ ID: %d, TEMP: %.2f ]", l->id, l->temp);
            l = l-> next;
        }
        printf ("\n");
    }
}

/* Destruye todos los elementos de una lista liberando la memoria */
void  destruir (TLista  *l)
{
    TLista  aux;
    while ( *l != NULL ) {
        aux = *l;
        *l = (*l)->next;
        free (aux);
    }
}

/* función auxiliar */
node*  buscar_id (int  id, TLista  *l)
{
    node  *current = *l;
    /* If the list is empty */
    if ( *l != NULL ) {
        if ( id > current->id ) {
            while ( current->next != NULL  &&  id > current->next->id ) {
                current = current->next;
            }
            if ( id != current -> id ) {
                current = NULL;
            }
        }
    }
    return  current;
}

/*
 * Añade una nueva variable a la estructura indicando el identificador de la
 * muestra (id) y el valor de temperatura (temp)
 */
void  insertar_muestra (int  id, float  temp, TLista  *l)
{
    node  *current = *l, *prev = *l;

    /* Create and setup the new node */
    node  *new = malloc (sizeof *new);

    if ( new == NULL ) {
        printf ("Memory not available to create link. Exiting\n");
        exit (EXIT_FAILURE);
    }
    new->id = id;
    new->temp = temp;
    new->next = NULL;

    /* If the list is empty */
    if ( *l == NULL ) {
        *l = new;
    }
    else {
        if ( id < current->id ) {
            new->next = current;
            *l = new;
        }
        else {
            while ( current != NULL  &&  current->id < id ) {
                prev = current;
                current = current->next;
            }
            if ( current == NULL ) {
                prev->next = new;
            }
            else if ( id != current -> id ) {
                new->next = current;
                prev->next = new;
            }
        }
    }
}

/*
 * Borra la muestra cuyo id coincida con el suministrado. Si el borrado tiene éxito,
 * en ok se almacenará un 1. En caso de no encontrarse, en ok se almacenará un
 * valor 0 indicando que el borrado ha fallado.
 */
void  borrar_muestra (int  id, TLista  *l, int  *ok)
{
    node *current = *l, *prev = *l;
    *ok = 0;

    while ( current != NULL  &&  current->id < id ) {
        prev = current;
        current = current->next;
    }

    if ( current != NULL  &&  current->id == id ) {
        *ok = 1;
        /* If it's the first node */
        if ( current == *l ) {
            *l = (*l)->next;
        }
        /* If it's a middle node */
        else {
            prev->next = current->next;
        }
        free (current);
    }
}

/* Calcula la media de todas las muestras almacenadas cuyo valor supere el umbral indicado. */
float  promedio_temp (TLista  l, float  umbral)
{
    int    i = 0;
    float  sum = 0;

    while ( l != NULL ) {
        if ( l->temp > umbral ) {
            sum += l->temp;
            ++i;
        }
        l = l->next;
    }

    return  sum / i;
}
