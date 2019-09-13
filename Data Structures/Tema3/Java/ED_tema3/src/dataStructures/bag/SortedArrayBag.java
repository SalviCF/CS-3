/********************************************************************
 * 
 * Ejercicio 12.c de la tercera relación
 *              Implementar el TAD Bolsa en java
 *
 * 
 * @author Salvi CF
 * 
 ********************************************************************
 */

package dataStructures.bag;

import java.util.Arrays;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class SortedArrayBag<T extends Comparable<? super T>> implements Bag<T> {

	private final static int INITIAL_CAPACITY = 5;

	protected T[] value; // Mantener este array ordenado
	protected int[] count; // Mantener este array con valores positivos
	protected int nextFree;
	
	// Iterator
	public Iterator<T> iterator(){
		return new SortedArrayBagIterator();
	}
	
	private class SortedArrayBagIterator implements Iterator<T>{
		int current;
		int cont = 1;
		
		public SortedArrayBagIterator(){
			current = 0;
		}
		
		public boolean hasNext(){
			return current != nextFree;
		}
		
		public T next(){
			if (!hasNext()){
				throw new NoSuchElementException();
			}
			T x = value[current];
			
			if (cont == count[current]){
				current++;
				cont = 1;
			} else {
				cont++;
			}
			
			return x;
		}
	}
	// End Iterator

	public SortedArrayBag() {
		this(INITIAL_CAPACITY);
	}

	@SuppressWarnings("unchecked")
	public SortedArrayBag(int n) {
		value = (T[]) new Comparable[n]; // Cada elemento es null
		count = new int[n]; // Cada elemento es 0
		nextFree = 0;
	}

	/**
	 * Asegura que cabe un elemento nuevo
	 */
	private void ensureCapacity() {
		if (nextFree == value.length) {
			value = Arrays.copyOf(value, 2 * value.length); // copy the values
			count = Arrays.copyOf(count, 2 * count.length); // copy the counters
		}
	}

	/**
	 * Devuelve si el bag esta vacio
	 */
	public boolean isEmpty() {
		return nextFree == 0;
	}

	/**
	 * Localiza la posicion donde esta o deberia estar un elemento. Si "item"
	 * aparece en el array "value", devuelve su indice en otro caso, devuelve el
	 * indice donde "item" deberia estar
	 * 
	 * @param item
	 *            el elemento a localizar
	 * @return indice donde esta o deberia estar "item"
	 */
	private int locate(T item) {
		int lower = 0;
		int upper = nextFree - 1;
		int mid = 0;
		boolean found = false;

		// Busqueda binaria
		while (lower <= upper && !found) {
			mid = lower + ((upper - lower) / 2); // == (lower + upper) / 2;
			found = value[mid].equals(item);
			if (!found) {
				if (value[mid].compareTo(item) > 0) { // number of the array is greater
					upper = mid - 1; // upper bound decreases
				} else {
					lower = mid + 1; // lower bound increases
				}
			}
		}

		if (found)
			return mid; // El indice donde "item" esta almacenado
		else
			return lower; // el indice donde "item" deberia insertarse
	}

	/**
	 * Inserta un elemento en el bag
	 * Si ya esta, incrementa su contador
	 * en otro caso, lo incluye con contador 1
	 */
	public void insert(T item) {
		int i = locate(item);
		if (i<value.length && value[i] != null && value[i].equals(item)) {
			
			count[i]++;
		// i<value.length avoids ArrayIndexOutOfBoundsException
		} else {
			ensureCapacity();
			// desplaza los elementos a derecha
			for (int j = nextFree; j > i; j--) {
				value[j] = value[j - 1];
				count[j] = count[j - 1];
			}

			value[i] = item;
			count[i] = 1;
			
			nextFree++;

		}
	}

	/**
	 * Devuelve las ocurrencias de "item".
	 * Devuelve 0 si no esta
	 */
	public int occurrences(T item) {
		int result = 0;
		int i = locate(item);
		
		// i<value.length avoids ArrayIndexOutOfBoundsException
		if (i<value.length && value[i] != null && value[i].equals(item)) {

			result = count[i];

		} 
		return result;
	}

	/**
	 * Elimina "item" del bag.
	 * Si aparece mas de una vez se decrementa el contador
	 * Si solo aparece una vez se elimina
	 * Si no esta, no se hace nada
	 */
	public void delete(T item) {
		int i = locate(item);

		// i<value.length avoids ArrayIndexOutOfBoundsException
		if (value[i] != null && value[i].equals(item)){ // value is in the bag
			if (count[i] > 1){ // appears 2 or more times
				
				count[i]--;
				
			} else { // appears only 1 time
				
				if (i == nextFree -1){ //deleting the last one
					nextFree--;
				} else { // deleting first or medium element
					
					// desplaza los elementos a izquierda
					for (int j = i; j < nextFree-1; j++) {
						value[j] = value[j + 1];
						count[j] = count[j + 1];
						
					} 
					nextFree--;
				}
			}
		}
	}

	/**
	 * Deuelve una representaciÃ³n textual del bag
	 */
	public String toString() {
		String text = "SortedArrayBag( ";
		for (int i = 0; i < nextFree; i++) {
			text += "(" + value[i] + ", " + count[i] + ") ";
		}
		return text + ")";
	}
}
