/*
 * LinkedList_Operations.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef LINKEDLIST_OPERATIONS_H_
#define LINKEDLIST_OPERATIONS_H_

// Structures
struct nodo {
    int num;
    struct nodo *next;
};

// Typedefs
typedef struct nodo Nodo;
typedef Nodo *pNodo;

// Prototypes
pNodo create(); //!
int length(pNodo); //!
void display(pNodo); //!
void append(pNodo*); //!
void appendMulti(pNodo*); //!
int findNode(pNodo); //!
void appendSeveral(pNodo*); //!
void insertAtBeginning(pNodo*); //!
void insertAtNth(pNodo*); //!
void deleteFirst(pNodo*); //!
void deleteLast(pNodo*); //!
void deleteAtNth(pNodo*); //!
void reverseList(pNodo*); //!
void swapNodes(pNodo*); //!
void swapAdjacents(pNodo*); //!
void myswap(int*, int*); //!
void sortList(pNodo*); //!
void insertSort(pNodo*); //!


#endif /* LINKEDLIST_OPERATIONS_H_ */
