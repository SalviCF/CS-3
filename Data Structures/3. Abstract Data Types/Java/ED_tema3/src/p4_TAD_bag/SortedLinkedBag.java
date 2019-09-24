/********************************************************************
 * 
 * Ejercicio 12.b de la tercera relaci�n
 *              Implementar el TAD Bolsa en java
 *
 *
 * @author Salvi CF
 * 
 ********************************************************************
 */

package p4_TAD_bag;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class SortedLinkedBag<T extends Comparable<? super T>> implements Bag<T> {

	static private class Node<E> {
		E elem;
		int count;
		Node<E> next;

		Node(E x, int n, Node<E> node) {
			elem = x;
			count = n;
			next = node;
		}
	}

	private Node<T> first; // Mantener esta lista enlazada ordenada por "elem"
	
	// Iterator
	public Iterator<T> iterator(){
		return new SortedLinkedBagIterator();
	}
	
	private class SortedLinkedBagIterator implements Iterator<T>{
		Node<T> current; // node to visit
		int cont = 1; // for returning n occurrences
		
		public SortedLinkedBagIterator(){
			current = first; // we start visiting the first node
		}
		
		public boolean hasNext(){
			return current != null; // Are all the nodes visited?
		}
		
		public T next(){
			if (!hasNext()){
				throw new NoSuchElementException();
			}
			T x = current.elem; // element of the the actual node
			
			if (cont == current.count){
				current = current.next; // advance to the next node
				cont = 1; // set the counter back to 1 
			} else {
				cont++;
			}
			
			return x;
		}
	}
	// End Iterator

	public SortedLinkedBag() {
		first = null;
	}

	/**
	 * Devuelve si el bag esta vacio
	 */
	public boolean isEmpty() {

		return first == null;
	}

	/**
	 * Inserta un elemento en el bag
	 * Si ya esta, incrementa su contador
	 * en otro caso, lo incluye con contador 1
	 */
	public void insert(T item) {
		Node<T> previous = null;
		Node<T> current = first;

		while (current != null && current.elem.compareTo(item) < 0) {
			previous = current;
			current = current.next;
		}

		if (current != null && current.elem.equals(item)) { // increment occurrences

			current.count++;
			
		} else if (previous == null) { // empty bag, first == null OR insert at beginning
			
			first = new Node<T>(item, 1, first); // (item, occurrences, next node)
			
		} else { // not empty bag, no insertion at beginning

			previous.next = new Node<T>(item, 1, current);

		}
	}

	/**
	 * Devuelve las ocurrencias de "item".
	 * Devuelve 0 si no esta
	 */
	public int occurrences(T item) {
		Node<T> current = first;
		int result = 0;

		while (current != null && current.elem.compareTo(item) < 0) {
			current = current.next;
		}

		if (current != null && current.elem.equals(item)) { // the element was in the list

			result = current.count;

		}
		return result; 
		// if the element wasn't in the list, current == null and result is not modified (0) 
	}

	/**
	 * Elimina "item" del bag.
	 * Si aparece mas de una vez se decrementa el contador
	 * Si solo apercce una vez se elimina
	 * Si no esta, no se hace nada
	 */
	public void delete(T item) {
		Node<T> previous = null;
		Node<T> current = first;
		
		while (current != null && current.elem.compareTo(item) < 0) {
            previous = current;
            current = current.next;
        } // current == null if element not found or if the list is empty

        if (current != null && current.elem.equals(item)){ // delete or decrease
        	if (current.count > 1){ // decrease
        		current.count--;
        	} else {
        		if (current == first){ 
        			first = first.next;
        		}
        		else {
        			previous.next = current.next;
        		}
        	}
        }

	}

	/**
	 * Deuelve una representaciÃ³n textual del bag 
	 */
	public String toString() {
		String text = "SortedLinkedBag( ";
		for (Node<T> p = first; p != null; p = p.next) {
			text += "(" + p.elem + ", " + p.count + ") ";
		}
		return text + ")";
	}
}
