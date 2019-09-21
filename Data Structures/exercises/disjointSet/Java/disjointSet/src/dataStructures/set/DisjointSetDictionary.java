/**
 * Data Structures
 * @author Salvi CF 
 */

package dataStructures.set;

import java.util.Iterator;

import dataStructures.dictionary.AVLDictionary;
import dataStructures.dictionary.Dictionary;
import dataStructures.list.ArrayList;
import dataStructures.list.List;

public class DisjointSetDictionary<T extends Comparable<? super T>> implements DisjointSet<T> {

    private Dictionary<T, T> dic;

    /**
     * Inicializa las estructuras necesarias.
     */
    public DisjointSetDictionary() {
        // TODO
    	dic = new AVLDictionary<>();
    }

    /**
     * Devuelve {@code true} si el conjunto no contiene elementos.
     */
    @Override
    public boolean isEmpty() {
        // TODO
    	return dic.isEmpty();
    }

    /**
     * Devuelve {@code true} si {@code elem} es un elemento del conjunto.
     */
    @Override
    public boolean isElem(T elem) {
        // TODO
       return dic.isDefinedAt(elem);
    }

    /**
     * Devuelve el numero total de elementos del conjunto.
     */

    @Override
    public int numElements() {
        // TODO
       return dic.size();
    }

    /**
     * Agrega {@code elem} al conjunto. Si {@code elem} no pertenece al
     * conjunto, crea una nueva clase de equivalencia con {@code elem}. Si
     * {@code elem} pertencece al conjunto no hace nada.
     */
    @Override
    public void add(T elem) {
        // TODO
    	if (!dic.isDefinedAt(elem))
    		dic.insert(elem, elem);
    }

    /**
     * Devuelve el elemento canonico (la raiz) de la clase de equivalencia la
     * que pertenece {@code elem}. Si {@code elem} no pertenece al conjunto
     * devuelve {@code null}.
     */
    private T root(T elem) {
        // TODO    	
    	for (T e : dic.keys()){
    		if (e == dic.valueOf(e))
    			return e;
    	}
    	
    	return null;
    }

    /**
     * Devuelve {@code true} si {@code elem} es el elemento canonico (la raiz)
     * de la clase de equivalencia a la que pertenece.
     */
    private boolean isRoot(T elem) {
        // TODO
    	return this.root(elem) == elem;
    }

    /**
     * Devuelve {@code true} si {@code elem1} y {@code elem2} estan en la misma
     * clase de equivalencia.
     */
    @Override
    public boolean areConnected(T elem1, T elem2) {
        // TODO
    	if (this.root(elem1) == this.root(elem2))
    		return true;
    	
    	return false;
    }

    /**
     * Devuelve una lista con los elementos pertenecientes a la clase de
     * equivalencia en la que esta {@code elem}. Si {@code elem} no pertenece al
     * conjunto devuelve la lista vacia.
     */
    @Override
    public List<T> kind(T elem) {
        // TODO
    	List<T> clase = new ArrayList<>();
    	for (T e : dic.keys()){
    		if (this.areConnected(e, elem))
    			clase.append(e);
    	}
    	return clase;
    }

    /**
     * Une las clases de equivalencias de {@code elem1} y {@code elem2}. Si
     * alguno de los dos argumentos no esta en el conjunto lanzara una excepcion
     * {@code IllegalArgumenException}.
     */
    @Override
    public void union(T elem1, T elem2) {
        // TODO
    	if (!this.isElem(elem1) || !this.isElem(elem2))
    		throw new IllegalArgumentException ("missing element(s)");
    	
    	T rx, ry;
    	rx = this.root(elem1);
    	ry = this.root(elem2);
    	if (rx.compareTo(ry) < 0){
    		dic.insert(ry, rx);
    	} else {
    		dic.insert(rx, ry);
    	}
    		
    }

    // ====================================================
    // A partir de aqui solo para alumnos a tiempo parcial
    // que no sigan el proceso de evaluacion continua.
    // ====================================================

    /**
     * Aplana la estructura de manera que todos los elementos se asocien
     * directamente con su representante canonico.
     */
    @Override
    public void flatten() {
        // TODO
    	for (T e : dic.keys()){
    		dic.insert(e, this.root(e));
    	}
    }

    /**
     * Devuelve una lista que contiene las clases de equivalencia del conjunto
     * como listas.
     */
    @Override
    public List<List<T>> kinds() {
        // TODO
    	List<List<T>> clases = new ArrayList<>();
    	for (T e : dic.keys()){
    		if (this.isRoot(e))
    			clases.append(this.kind(e));
    	}
    	
        return clases;
    }

    /**
     * Devuelve una representacion del conjunto como una {@code String}.
     */
    @Override
    public String toString() {
        return "DisjointSetDictionary(" + dic.toString() + ")";
    }
}
