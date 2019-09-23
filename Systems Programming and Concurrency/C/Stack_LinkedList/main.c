/*
 ============================================================================
 Name        : Stack_LinkedList.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

int main(void) {

    pNodo top = NULL;
    int op;

    while (1){
        printf("Stack operations using linked list:\n\n");
        printf("1. Push\n");
        printf("2. Push several\n");
        printf("3. Pop\n");
        printf("4. Pop several\n");
        printf("5. Display stack\n");
        printf("6. Quit\n\n");

        printf("Enter the code of the operation you want to perform: ");
        fflush(stdout);
        scanf("%d", &op);

        switch (op)
        {
            case 1: push(&top); break;
            case 2: pushSeveral(&top); break;
            case 3: pop(&top); break;
            case 4: popSeveral(&top); break;
            case 5: traverse(top); break;
            case 6: exit(1);
            default: perror("Invalid operation\n");

        }
    }

	return EXIT_SUCCESS;
}
