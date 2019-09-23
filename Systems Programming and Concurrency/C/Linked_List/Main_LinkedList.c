/*
 ============================================================================
 Name        : Main_LinkedList.c
 Author      : Salvi CF
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include "LinkedList_Operations.h"

int main(void) {

	pNodo head = create();
	int op;

	while (1){
		printf("__________________________________________________________________________");
		printf("\n");
		printf("\nSingle linked list operations: \n\n");
		printf("1. Append\t\t\t 9. Find a node that stores a given number\n");
		printf("2. Insert at beginning\t\t 10. Swap adjacent nodes\n");
		printf("3. Insert at n-th position\t 11. Swap non-adjacent nodes\n");
		printf("4. Show the length\t\t 12. Reverse the list\n");
		printf("5. Display the list\t\t 13. Sort the list\n");
		printf("6. Delete the first\t\t 14. Insert a node maintaining order\n");
		printf("7. Delete last one\t\t 15. Append multiples\n");
		printf("8. Delete the n-th element\t 16. Append several\n");
		printf("\t\t\t\t 17. Quit\n");
		printf("__________________________________________________________________________\n");

	    printf("Enter the code of the operation you want to perform: ");
	    fflush(stdout);
	    scanf("%d", &op);

	    switch (op)
	    {
	    	case 1: append(&head); break;
	    	case 2: insertAtBeginning(&head); break;
	    	case 3: insertAtNth(&head); break;
	    	case 4: printf("The length of the list is: %d\n", length(head)); break;
	    	case 5: display(head); break;
	    	case 6: deleteFirst(&head); break;
	    	case 7: deleteLast(&head); break;
	    	case 8: deleteAtNth(&head); break;
	    	case 9: printf("A node that stores that number is in the position %d\n", findNode(head)); break;
	    	case 10: swapAdjacents(&head); break;
	    	case 11: swapNodes(&head); break;
	    	case 12: reverseList(&head); break;
	    	case 13: sortList(&head); break;
	    	case 14: insertSort(&head); break;
	    	case 15: appendMulti(&head); break;
	    	case 16: appendSeveral(&head); break;
	    	case 17: exit(1);
	    	default: perror("Invalid choice\n");
	    }
	}

	return EXIT_SUCCESS;
}
