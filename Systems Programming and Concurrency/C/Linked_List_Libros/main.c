/*
 ============================================================================
 Name        : Linked_List_Libros.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lista.h"

int main(void) {

    Lista milista;
    milista.head = NULL;
    milista.longitud = 0;

    int op;
    int n;
    while (1){
    	fflush(stdout);
        printf("\nSingle linked list operations (Library): \n\n");
        printf("1. Append a book\n");
        printf("2. Insert a book at beginning\n");
        printf("3. Insert a book after the n-th position\n");
        printf("4. How many books are in the list?\n");
        printf("5. Display the list\n");
        printf("6. Delete the first book\n");
        printf("7. Delete last book\n");
        printf("8. Delete the n-th book\n");
        printf("9. Quit\n\n");

        printf("Enter the code of the operation you want to perform: ");
        fflush(stdout);
        scanf("%d", &op);

        switch (op)
        {
            case 1: InsertarFinal(&milista, CrearLibro()); break;
            case 2: InsertarPrincipio(&milista, CrearLibro()); break;
            case 3:
                printf("Enter the position after which you want to insert the book ");
                printf("(0 is the first position): ");
                fflush(stdout);
                scanf("%d", &n);
                InsertarDespues(n, &milista, CrearLibro()); break;
            case 4: printf("The length of the list is: %d\n", Contar(&milista)); break;
            case 5: MuestraLista(&milista); break;
            case 6: EliminarPrimero(&milista); break;
            case 7: EliminarUltimo(&milista); break;
            case 8:
                printf("What position do you want to delete? ");
                printf("(0 is the first position): ");
                fflush(stdout);
                scanf("%d", &n);
                EliminarN(n, &milista); break;
            case 9: exit(1);
            default: perror("Invalid choice\n");

        }
    }

    return 0;
}
