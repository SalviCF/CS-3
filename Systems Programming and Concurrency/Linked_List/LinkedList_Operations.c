/*
 * LinkedList_Operations.c
 *
 * 
 *      Author: Salvi CF
 */
#include <stdio.h>
#include <stdlib.h>
#include "LinkedList_Operations.h"

pNodo create(){
	return NULL;
}

int length(pNodo head){
	pNodo iter = head;
	int cont = 0;
	while (iter != NULL){
		iter = iter->next;
		cont++;
	}
	return cont;
}

void display(pNodo head){
	printf("Linked list:\t");
	pNodo iter = head;
	 while (iter != NULL){
		 printf("%d --> ", iter->num);
	     iter = iter->next;
	 } printf("NULL\n");
}

void append(pNodo *pHead){
	pNodo temp = malloc(sizeof(Nodo));
	    printf("Enter the value of the node: ");
	    fflush(stdout);
	    scanf("%d", &temp->num);
	    temp->next = NULL;

	    if (*pHead == NULL){
	        *pHead = temp;
	    } else {
	        pNodo iter = *pHead;
	        while (iter->next != NULL){
	            iter = iter->next;
	        }
	        iter->next = temp;
	    }
}

void appendMulti(pNodo *pHead){
	int elem;
		printf("How many elements want to append? ");
		fflush(stdout);
		scanf("%d", &elem);

		while (elem){
			append(pHead);
			elem--;
		}
}

int findNode(pNodo head){
	printf("Enter the number you want to find: ");
	fflush(stdout);
	int cont = 1;
	int elem; scanf("%d", &elem);
	pNodo iter = head;
	if (iter == NULL){ return -1; }
	while ((iter->num != elem) && (iter->next != NULL)){
		iter = iter->next;
		cont++;
	}
	if (iter->num == elem){ return cont; }
	else { return -1; }
}

void appendSeveral(pNodo *pHead){
	char c; int ctrl=1;
	while (ctrl){
		printf("Do you want to append a node? (y/n): ");
	    fflush(stdin); fflush(stdout);
	    c = getchar();
	    if (c == 'n'){ ctrl = 0; }
	    else { append(pHead); }
	}
}

void insertAtBeginning(pNodo *pHead){
	pNodo temp = malloc(sizeof(Nodo));
	printf("Enter the value of the node: ");
	fflush(stdout);
	scanf("%d", &temp->num);
	temp->next = NULL;

	if (*pHead == NULL){
		*pHead = temp;
	} else {
		temp->next = *pHead;
	    *pHead = temp;
	}
}

void insertAtNth(pNodo *pHead){
	printf("Insert at n-th position\n");
	printf("Enter the position that the node will occupy (the first position is 1): ");
	fflush(stdout);
	int pos; scanf("%d", &pos);

	if (pos<1 || pos>(length(*pHead)+1)){
		perror("Invalid position\n");
	} else {
		pNodo temp = malloc(sizeof(Nodo));
	    printf("Insert the integer to store in the node: ");
	    fflush(stdout);
	    scanf("%d", &temp->num);
	    temp->next = NULL;

	    pNodo iter = *pHead;
	    int cont = 1;
	    if (pos == 1){
	    	temp->next = *pHead;
	        *pHead = temp;
	    } else {
	    	while (cont < pos-1){
	        iter = iter->next;
	        cont++;
	    	}
	        temp->next = iter->next;
	        iter->next = temp;
	    }
	}
}

void deleteFirst(pNodo *pHead){
	if (*pHead == NULL){ printf("The list is already empty\n"); }
	else {
		pNodo temp = *pHead;
		*pHead = (*pHead)->next;
	    temp->next = NULL;
	    free(temp);
	}
}

void deleteLast(pNodo *pHead){
	if (*pHead == NULL){ printf("The list is already empty\n"); }
	else {
	    pNodo iter = *pHead;
	    while (iter->next->next != NULL){
	        iter = iter->next;
	    }
	    free(iter->next);
	    iter->next = NULL;
	}
}

void deleteAtNth(pNodo *pHead){
    pNodo temp = *pHead;
    printf("Delete the node that occupies the position: ");
    fflush(stdout);
    int pos; scanf("%d", &pos);

    if (pos > length(*pHead) || pos < 1){
        perror("Invalid position");
        printf("There are %d nodes in the list", length(*pHead));
    } else if (pos == 1){
    	*pHead = temp->next;
        temp->next = NULL;
        free(temp);
    } else {
        pNodo aux;
        int cont = 1;
        while (cont < pos-1){
            temp = temp->next;
            cont++;
        }
        aux = temp->next; // temp->next = (temp->next)->next;
        temp->next = aux->next; // (temp->next)->next = NULL;
        aux->next = NULL;
        free(aux);
    }
}

void reverseList(pNodo *pHead){
    // Initial pointers
    pNodo prev, current, sig;
    prev = NULL;
    current = *pHead;

    // Operations
    while (current != NULL){ // adjust each link
        sig = current->next;
        current->next = prev;
        prev = current;
        current = sig;
    }
    *pHead = prev;
}

void swapNodes(pNodo *pHead){
    printf("Enter the position of the two nodes to swap, separated by a space: ");
    fflush(stdout);
    int node1, node2; scanf("%d %d", &node1, &node2);

    if (node1 == node2){ return; }

    if (node1>node2){ // sorting the nodes in ascending order
        int aux = node2;
        node2 = node1;
        node1 = aux;
    }

    if (node2 > length(*pHead)){ // we know node 2 is greater or equal to node 1 after sorting
        perror("Invalid position");
    } else { // the swapping can be done
        if (node1 == 1){// when first node is involved in the swap
            pNodo n1, n2, aux1, aux2;
            if (node2 == 2){ // when the nodes involved are the first and the second
                aux1 = *pHead;
                *pHead = (*pHead)->next;
                aux1->next = (*pHead)->next;
                (*pHead)->next = aux1;
                aux1 = NULL;
            } else { // swap first node with another (except for the second node)
                n1 = n2 = *pHead;
                int cont = 1;
                while (cont < node2-1){
                    n2 = n2->next;
                    cont++;
                }
                aux1 = (*pHead)->next;
                aux2 = n2->next;

                *pHead = aux2;
                n1->next = aux2->next;
                aux2->next = aux1;
                n2->next = n1;
            }
        } else { // node 1 is not involved in the swap
            ////
            pNodo n1, n2, aux1, aux2;
            n1 = *pHead;
            int cont = 1;
            while (cont < node1-1){
            n1 = n1->next;
            cont++;
        }
        n2 = n1;
        while (cont < node2-1){
            n2 = n2->next;
            cont++;
        }
        // Initial pointers
        aux1 = n1->next;
        aux2 = n2->next;

        // Operations
        n1->next = aux2;
        n2->next = aux1;
        n1 = aux1->next;
        aux1->next = aux2->next;
        aux2->next = n1;
        }
    }
}

void swapAdjacents(pNodo *pHead){
    printf("Enter the position of the node. It will be swapped with the next node: ");
    fflush(stdout);
    int loc; scanf("%d", &loc);
    pNodo iter, aux1, aux2;
    iter = *pHead;
    int cont = 1;

    if (loc<1 || loc>=length(*pHead)){
    	perror("Invalid position");
    } else {
    	if (loc==1){
    		aux1 = (*pHead)->next;
    		aux2 = aux1->next;

    		(*pHead)->next = aux2;
    		aux1->next = *pHead;
    		*pHead = aux1;
    	} else {
            while (cont < loc-1){
                iter = iter->next;
                cont++;
            }
            // Initial pointers
            aux1 = iter->next;
            aux2 = aux1->next;

            // Operations
            iter->next = aux2;
            aux1->next = aux2->next;
            aux2->next = aux1;
    	}
    }
}

void sortList(pNodo *pHead){
    int i, j, n;
    n = length(*pHead);
    pNodo pi, pj;
    pi = pj = *pHead;

    for (i=0; i<n-1; i++){
        for (j=0; j<n-i-1; j++){//j=i->next (iterating over the pointers, but I have to reach until NULL)
            if (pj->num > (pj->next)->num){ myswap(&(pj->num), &((pj->next)->num)); }
            pj = pj->next;
        }
        pi = pi->next;
        pj = *pHead;
    }
}

void myswap(int *x, int *y){
    int aux = *x;
    *x = *y;
    *y = aux;
}

void insertSort(pNodo *pHead){
    pNodo temp, iter, prev;
    temp = malloc(sizeof(Nodo));
    printf("Enter the value: ");
    fflush(stdout);
    scanf("%d", &temp->num);
    temp->next = NULL;

    if (*pHead == NULL){
    	*pHead = temp;
    } else if (temp->num < (*pHead)->num){// insert at beginning
            temp->next = *pHead;
            *pHead = temp;
    } else {
        prev = *pHead;
        iter = (*pHead)->next;
        while (iter != NULL && temp->num > iter->num){
            prev = iter;
            iter = iter->next;
        }
        temp->next = iter;
        prev->next = temp;
    }
}