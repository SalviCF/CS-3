/*
 * MProcesos.c
 *
 *  
 *      Author: Salvi CF
 */

#include  "MProcesos.h"
#include  <stdio.h>
#include  <stdlib.h>

/* Crea una lista de procesos vacía */
void  Crear (LProc  *lroundrobin)
{
    lroundrobin = NULL;
    // *lroundrobin = malloc (sizeof *lroundrobin);
    // (*lroundrobin)->next = *lroundrobin;
}

/*
 * Añade el proceso con identificador idproc a la lista de procesos disponibles para ejecución.
 * Este proceso se añade como el último nodo que se ejecutará en modo Round Robin
 */
void  AnadirProceso (LProc  lroundrobin, int  idproc)
{
    nodePtr  new = malloc (sizeof new);
    new->id = idproc;

    /* if the list is empty */
    if ( lroundrobin.last == NULL ) {
        lroundrobin.last = new;
        new->next = new;
    }
    else {
        new->next = lroundrobin.last->next;
        lroundrobin.last->next = new;
        lroundrobin.last = new;
    }
}

/*
 * Realiza un recorrido sobre la lista simulando la ejecución del quantum de tiempo
 * de la lista de procesos. La ejecución de cada proceso se simula escribendo su
 * identificador en la pantalla.
 */
void  EjecutarProcesos (LProc  lroundrobin) {
    if ( lroundrobin.last != NULL ) {
        nodePtr current = lroundrobin.last->next;

        while ( current != lroundrobin.last ) {
            printf ("%d\n", current->id);
            current = current->next;
        }
    }
}

/*
 * Elimina el proceso idproc que ya ha terminado su ejecución.
 * Suponemos que en la lista existe un proceso con ese identificador
 */
void  EliminarProceso (int  id, LProc  *lista)
{
    nodePtr  current = lista->last->next, prev = lista->last;

    while ( current != lista->last  &&  current->id != id ) {
        prev = current;
        current = current->next;
    }
    if ( current->id == id ) {
        /* if the node is the last */
        if ( current == lista->last ) {
            lista->last = prev;
            prev->next = current->next;
            free (current);
        }
        else {
            prev->next = current->next;
            free (current);
        }
    }
}

/*
 * Guarda la información en un fichero binario dejando la lista vacía y liberando memoria.
 * El fichero tendrá el formato siguiente:
 * <numero de procesos> <idproc><idproc>....
 */
void  EscribirFichero (char  *nomf, LProc  *lista)
{
    FILE  *fp;
    nodePtr current = lista->last->next, prev = lista->last;
    int  cont = 0;

    fp = fopen (nomf, "w+");

    while ( current != lista->last ) {
        current = current->next;
        ++cont;
    }

    current = lista->last->next;
    fprintf (fp, "%d procesos: ", cont);

    while ( current->next != lista->last ) {
        fprintf (fp, "%d, ", current->id);
        prev = current;
        free (current);
        current = prev->next;
    }
    fprintf (fp, "%d\n", current->next->id);

    fclose (fp);
}
