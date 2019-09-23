/*
 * stack.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef STACK_H_
#define STACK_H_

// Structures
struct nodo {
    int num;
    struct nodo *next;
};

// Typedefs
typedef struct nodo Nodo;
typedef struct nodo *pNodo;

// Global variables
//pNodo top;


// Prototypes
void push(pNodo*);
void pop(pNodo*);
void traverse(pNodo);
void pushSeveral(pNodo*);
void popSeveral(pNodo*);


#endif /* STACK_H_ */
