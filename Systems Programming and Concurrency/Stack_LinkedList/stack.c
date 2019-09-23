/*
 * stack.c
 *
 *  
 *      Author: Salvi CF
 */

#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

// Stack: last in, first out

void push(pNodo *pTop){
    pNodo temp = malloc(sizeof(Nodo));

    printf("Enter the value: ");
    fflush(stdout);
    scanf("%d", &temp->num);

    temp->next = *pTop;
    *pTop = temp;

}

void pop(pNodo *pTop){
    pNodo temp;

    if (*pTop == NULL){
        printf("There are no elements in the stack\n");
    }else{
        temp = *pTop;
        *pTop = (*pTop)->next;
        temp->next = NULL;
        free(temp);
    }
}

void traverse(pNodo top){
    pNodo iter;

    if (top == NULL){
        printf("Stack is empty\n");
    } else {
        iter = top;
        while (iter){ //iter != NULL
            printf("%d\n", iter->num);
            iter = iter->next;
        } printf("NULL\n\n");
    }
}

void pushSeveral(pNodo *pTop){
    printf("How many elements do you want to push? ");
    fflush(stdout);
    int n; scanf("%d", &n);
    int cont = 0;
    while (cont < n){
        push(pTop);
        cont++;
    }
}

void popSeveral(pNodo *pTop){
    printf("How many elements do you want to pop? ");
    fflush(stdout);
    int n; scanf("%d", &n);
    int cont = 0;
    while (cont < n){
        pop(pTop);
        cont++;
    }
}
