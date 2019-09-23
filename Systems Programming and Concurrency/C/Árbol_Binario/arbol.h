/*
 * arbol.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef ARBOL_H_
#define ARBOL_H_

typedef struct node {
    int valor;
    struct node *izq, *der;
} *TArbol;

/* Este procedimiento construye un árbol binario de búsqueda vacio. */
void CrearABB(TArbol *arb);

/*
 * Este procedimiento inserta elem en un árbol binario de búsqueda.
 * Después de la inserción el árbol DEBE seguir siendo un árbol binario de búsqueda.
 */
void InsertarEnABB(TArbol *arb, int elem);

/*
 * Dado un árbol binario de búsqueda, este procedimiento muestra en pantalla los
 * elementos del árbol ordenados de menor a mayor. Para el dibujo de la figura la
 * salida sería:
 * 1,4,5,6,7,15,21,45,77,78,80,90,99
 */
void RecorrerABB(TArbol arb);

/* Este procedimiento libera la memoria de todos los nodos del árbol. */
void DestruirABB(TArbol *arb);

#endif /* ARBOL_H_ */
